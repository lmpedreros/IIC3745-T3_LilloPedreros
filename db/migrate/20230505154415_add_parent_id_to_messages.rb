class AddParentIdToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :parent_id, :integer
    add_index :messages, :parent_id
  end
end
