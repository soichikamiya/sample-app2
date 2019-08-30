class Micropost < ApplicationRecord
  belongs_to :user
  # デフォルトで降順にする（新しいのが上）
  default_scope -> { order(created_at: :desc) }
  # 「->」というラムダ式(無名関数)はブロックを引数に取り Procオブジェクト を返し、
  # Procオブジェクトは callメソッド が呼ばれたとき、ブロック内の処理を評価します
  # -> { puts "foo" }.call ⇨ "foo"
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
