class Micropost < ApplicationRecord
  belongs_to :user
  # デフォルトで降順にする（新しいのが上）
  default_scope -> { order(created_at: :desc) }
  # 「->」というラムダ式(無名関数)はブロックを引数に取り Procオブジェクト を返し、
  # Procオブジェクトは callメソッド が呼ばれたとき、ブロック内の処理を評価します
  # -> { puts "foo" }.call ⇨ "foo"

  # Micropostモデルに画像データを追加する
  # CarrierWaveに画像と関連付けたモデルを伝えるためには、mount_uploaderというメソッドを使い、
  # 引数に属性名のシンボルと生成されたアップローダーのクラス名を取ります。
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # このvalidateメソッドでは引数にシンボルを取り、そのシンボル名に対応したメソッドを呼び出す
  validate :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        # 5MBを超えた場合はカスタマイズしたエラーメッセージをerrorsコレクションに追加
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
