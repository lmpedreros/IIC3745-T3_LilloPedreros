require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com',
                         role: 'admin')
    @product = Product.new(nombre: 'John1', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
  end

  test 'is valid with valid attributes' do
    assert @product.valid?
  end
end
