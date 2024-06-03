class AddProductsToShoppingCart < ActiveRecord::Migration[7.0]
  def change
    add_column :shopping_carts, :products, :jsonb
  end
end
