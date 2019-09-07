class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # 両方のキーを同時に扱う複合キーインデックス (Multiple Key Index) を作成する。
    # follower_idとfollowed_idの組み合わせが必ずユニークであることを保証する仕組みで、
    # これにより、あるユーザーが同じユーザーを2回以上フォローすることを防ぐ。
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
