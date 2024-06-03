require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com',
                         role: 'admin')
    sign_in @user
    @product = Product.create!(nombre: 'John1', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
  end

  test 'should get index' do
    get '/products/index'
    assert_response :success
  end

  test 'should get index with user logout' do
    sign_out @user
    get '/products/index'
    assert_response :success
  end
end
