# spec/models/shopping_cart_spec.rb
require_relative '../../spec/rails_helper'

RSpec.describe ShoppingCart, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }
  let(:product1) { Product.create(name: 'Product 1', price: 1000) }
  let(:product2) { Product.create(name: 'Product 2', price: 2000) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      shopping_cart = ShoppingCart.new(user: user, products: { product1.id.to_s => 2, product2.id.to_s => 1 })
      expect(shopping_cart).to be_valid
    end

    it 'is not valid without a user' do
      shopping_cart = ShoppingCart.new(products: { product1.id.to_s => 2, product2.id.to_s => 1 })
      expect(shopping_cart).to_not be_valid
    end
  end

  describe '#precio_total' do
    it 'calculates the total price of products in the shopping cart' do
      shopping_cart = ShoppingCart.create(user: user, products: { product1.id.to_s => 2, product2.id.to_s => 1 })
      expect(shopping_cart.precio_total).to eq(4000)
    end

    it 'returns 0 if the shopping cart is empty' do
      shopping_cart = ShoppingCart.create(user: user, products: {})
      expect(shopping_cart.precio_total).to eq(0)
    end
  end

  describe '#costo_envio' do
    it 'calculates the shipping cost for the shopping cart' do
      shopping_cart = ShoppingCart.create(user: user, products: { product1.id.to_s => 2, product2.id.to_s => 1 })
      expect(shopping_cart.costo_envio).to eq(350)
    end

    it 'returns the fixed shipping cost if the shopping cart is empty' do
      shopping_cart = ShoppingCart.create(user: user, products: {})
      expect(shopping_cart.costo_envio).to eq(1000)
    end
  end
end