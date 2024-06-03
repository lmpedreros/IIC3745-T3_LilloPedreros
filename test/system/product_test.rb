require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com',
                         role: 'admin')
    login_as(@user, scope: :user)
  end
  test 'visiting crear form' do
    visit '/products/crear'
    assert_selector 'h1', text: 'Crear Producto'
  end

  test 'not allowed' do
    logout(:user)
    visit '/products/crear'
    assert_selector 'div', text: 'No estás autorizado para acceder a esta página'
  end
end
