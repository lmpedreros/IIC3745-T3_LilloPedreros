class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :nombre
      t.string :precio
      t.string :stock
      t.string :img
      t.string :url

      t.timestamps
      t.column :deleted_at, :datetime, :limit => 6
    end
  end
end
