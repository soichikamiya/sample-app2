class User < ApplicationRecord
  # passwordのような仮想属性を作成、remember_digestに保存する為処理を加える
  attr_accessor :remember_token

  # email属性を小文字に変換して全emailの一意性を保証する
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }

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
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    # bcrypt gemのソースコードにあるハッシュ値の比較方法
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
