class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    # デフォルトでnilになりfalseと同じ意味ではあるが、明示的にfalseを設定する
    add_column :users, :admin, :boolean, default: false
  end
end
