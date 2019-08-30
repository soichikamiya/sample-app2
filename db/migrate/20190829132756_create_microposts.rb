class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    # 1つの配列に含めることで、Active Recordは両方のキーを同時に扱う複合キーインデックス (Multiple Key Index) を作成する
    add_index :microposts, [:user_id, :created_at]
  end
end
