class AddDeseadosToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deseados, :string
  end
end
