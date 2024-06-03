class AddProductAndUserToSolicitud < ActiveRecord::Migration[7.0]
  def change
    add_reference :solicituds, :product, null: false, foreign_key: true
    add_reference :solicituds, :user, null: false, foreign_key: true
  end
end
