class AddUserIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :user_id, :integer
    add_index :products, :user_id
  end
end
