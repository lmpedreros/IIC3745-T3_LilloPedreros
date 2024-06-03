class RemoveParentIdFromMessages < ActiveRecord::Migration[7.0]
  def change
    remove_column :messages, :parent_id, :integer
  end
end
