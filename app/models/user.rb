class User < ApplicationRecord
  # micropostsはユーザーと一緒に破棄される
  has_many :microposts, dependent: :destroy
  # 能動的関係に対して1対多 (has_many) の関連付けを実装
  # follower_idは自分で、followed_idはフォローされた相手。user.active_relationships.create(followed_id: other_user.id)
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id", #能動なのでフォローを行ったユーザーとfollower_idは外部キーで繋がる
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id", #受動なのでフォローされたユーザーとfollowed_idは外部キーで繋がる
                                   dependent:   :destroy

  # Userモデルにfollowingの関連付けを追加
  # :sourceパラメーターで「following配列の元はfollowed idの集合である」ということを明示的にRailsに伝える
  has_many :following, through: :active_relationships, source: :followed
  # :followers属性の場合、Railsが「followers」を単数形にして自動的に外部キーfollower_idを探してくれるのでsource要らない
  has_many :followers, through: :passive_relationships

  # passwordのような仮想属性を作成、remember_digestに保存する為処理を加える
  attr_accessor :remember_token, :activation_token, :reset_token

  # email属性を小文字に変換して全emailの一意性を保証する
  # before_save { self.email = email.downcase }
  # before_save { email.downcase! }
  before_save   :downcase_email

  # オブジェクトの作成や更新時ではなくオブジェクトが作成された時だけコールバックを呼び出したい
  before_create :create_activation_digest

  # メソッド後ろの括弧を省略できる為 validates(:name, presence: true)と同じ
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    # 大文字小文字を区別せず一意か確認
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    # コストパラメータではハッシュを算出するための計算コストを指定. 値が高い程推測が困難
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    # 64種類の文字からなる長さ22の文字列
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのために記憶トークンをDBに記憶する
  def remember
    # ランダムトークンを作成し、remember_token属性に代入し、値をハッシュ値に変換し、remember_digestに更新する
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンが self.remember_digest と一致したらtrueを返す
  def authenticated?(attribute, token)
    # sendで与えるメソッドを動的に変えれる（メタプログラミングと呼ぶ。下記に例）
    # [1, 2, 3].length ⇨ 3
    # len = :length or "length"
    # [1, 2, 3].send(len) ⇨ 3

    # user.send("activation_digest") で user.activation_digest と同じになる
    digest = self.send("#{attribute}_digest") # user.remember_digest / user.activation_digest
    return false if digest.nil?
    # bcrypt gemのソースコードにあるハッシュ値の比較方法
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    # update_attribute(:reset_digest,  User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    # パスワード再設定メールの送信時刻が、現在時刻より2時間以上前 (早い) の場合
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す(自分の投稿＆フォローユーザーの投稿)
  def feed
    # 下記の疑問符があることで、SQLクエリに代入する前に self.id がエスケープされるため、
    # SQLインジェクション(深刻なセキュリティホール)を避けることが可能。
    # SQL文に変数を代入する場合は常にエスケープする
    # user.following_ids は user.following.map(&:id) と同じ結果を返すActive Recordが自動生成したメソッド

    # SQLのサブセレクト(サブクエリ)は集合のロジックを (Railsではなく) データベース内に保存するので、
    # より効率的にデータを取得することが可能。user_id IN (2,3,5,7,8,9,10) ではなく user_id IN (サブクエリ) となる。
    # 同じ変数を複数の場所に挿入したい場合は、whereメソッド内の変数にキーと値をペアにする文法を使う方が便利

    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    # ↓↓↓

    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"

    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # 下記3つは self を省略
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    # includeは user.microposts.count と同じくデータベースの中で直接比較をするので処理が高速
    following.include?(other_user)
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
