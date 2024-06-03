class RemoveEmailRestrictionsFromUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :email, :string, null: true, default: nil
  end
  
end
