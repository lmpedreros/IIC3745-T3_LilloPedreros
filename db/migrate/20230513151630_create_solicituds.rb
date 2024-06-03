class CreateSolicituds < ActiveRecord::Migration[7.0]
  def change
    create_table :solicituds do |t|
      t.string :status
      t.integer :stock
      t.timestamps
    end
  end
end
