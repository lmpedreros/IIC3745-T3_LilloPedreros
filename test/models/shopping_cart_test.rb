require 'test_helper'

class ShoppingCartTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com', role: 'admin')
    @product1 = Product.create!(nombre: 'Product1', precio: 1000, stock: 10, user: @user, categories: 'Cancha')
    @product2 = Product.create!(nombre: 'Product2', precio: 2000, stock: 5, user: @user,
                                categories: 'Accesorio tecnologico')
    @shopping_cart = ShoppingCart.new(user: @user, products: { @product1.id => 2, @product2.id => 1 })
  end

  test 'is valid with valid attributes' do
    assert @shopping_cart.valid?
  end

  test 'is invalid without user' do
    @shopping_cart.user = nil
    assert_not @shopping_cart.valid?
    assert_includes @shopping_cart.errors[:user], 'debe existir'
  end

  test 'is valid without products' do
    @shopping_cart.products = {}
    assert @shopping_cart.valid?
  end

  test 'total price is calculated correctly' do
    expected_total_price = (@product1.precio.to_i * 2) + (@product2.precio.to_i * 1)
    assert_equal expected_total_price, @shopping_cart.precio_total
  end

  test 'total price is zero with no products' do
    @shopping_cart.products = {}
    assert_equal 0, @shopping_cart.precio_total
  end

  test 'shipping cost is calculated correctly' do
    cost1 = (@product1.precio.to_i * 2 * 0.05).round(0)
    cost2 = (@product2.precio.to_i * 1 * 0.05).round(0)
    expected_shipping_cost = 1000 + cost1 + cost2
    assert_equal expected_shipping_cost, @shopping_cart.costo_envio
  end
end
