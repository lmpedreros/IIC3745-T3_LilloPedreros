require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com')
  end

  # Happy path: instancia válida de User
  test 'should be valid with valid attributes' do
    assert @user.valid?
  end

  # ----------------- Tests de validación de atributos ----------------- #
  # Camino alternativo: name no presente
  test 'should be invalid without a name' do
    # @user.name = ""
    @user.name = nil
    assert_not @user.valid?
  end

  # Camino alternativo: name demasiado corto
  test 'should be invalid if name is too short' do
    @user.name = 'A'
    assert_not @user.valid?
  end

  # Camino alternativo: name demasiado largo
  test 'should be invalid if name is too long' do
    @user.name = 'A' * 30
    assert_not @user.valid?
  end

  # Camino alternativo: email no presente
  test 'should be invalid without an email' do
    # @user.email = ""
    @user.email = nil
    assert_not @user.valid?
  end

  # Camino alternativo: email inválido   NO ESOTY SEGURO DE ESTE TEEEEST
  test 'is not valid with an invalid email' do
    @user.email = 'invalid_email'
    assert_not @user.valid?
  end

  # Camino alternativo: email no único
  test 'should be invalid with a non-unique email' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  # ----------------- Tests de Admin ----------------- #  REVISAAAAAAAAAAAAAAAAAAR
  # Test de función: admin?       NO ESOTY SEGURO DE ESTE TEEEEST
  test 'returns true if user is an admin' do
    @user.role = 'admin'
    assert @user.admin?
  end

  # NO ESOTY SEGURO DE ESTE TEEEEST
  test 'returns false if user is not an admin' do
    @user.role = 'user'
    assert_not @user.admin?
  end

  # ----------------- Tests de asociaciones ----------------- #
  test 'destroys associated products when user is destroyed' do
    @user.save
    @user.products.create!(nombre: 'Product1', precio: 100, stock: 10, categories: 'Cancha')
    assert_difference('Product.count', -1) do
      @user.destroy
    end
  end

  test 'destroys associated reviews when user is destroyed' do
    @user.save
    product = @user.products.create!(nombre: 'Product1', precio: 100, stock: 10, categories: 'Cancha')
    @user.reviews.create!(tittle: 'Great!', description: 'Loved it', calification: 5, product:)
    assert_difference('Review.count', -1) do
      @user.destroy
    end
  end

  test 'destroys associated messages when user is destroyed' do
    @user.save
    product = @user.products.create!(nombre: 'Product1', precio: 100, stock: 10, categories: 'Cancha')
    @user.messages.create!(body: 'Sample message', product:)
    assert_difference('Message.count', -1) do
      @user.destroy
    end
  end

  test 'destroys associated solicituds when user is destroyed' do
    @user.save
    product = @user.products.create!(nombre: 'Product1', precio: 100, stock: 10, categories: 'Cancha')
    @user.solicituds.create!(stock: 1, status: 'pending', product:)
    assert_difference('Solicitud.count', -1) do
      @user.destroy
    end
  end

  test 'destroys associated shopping_cart when user is destroyed' do
    @user.save
    @user.create_shopping_cart!(products: {})
    assert_difference('ShoppingCart.count', -1) do
      @user.destroy
    end
  end

  # ----------------- Tests de validación de validate_new_wish_product ----------------- #
  # Happy path de validate_new_wish_product
  test 'is valid if wish list product exists' do
    product = Product.create!(nombre: 'Producto', categories: 'Suplementos', stock: 8, precio: 9, user: @user)
    @user.deseados << product.id
    assert @user.valid?
  end

  # Camino alternativo: validación de deseados con producto que no existe
  test 'is not valid with a non-existing product in wish list' do
    @user.deseados << 9_999_999_999
    assert_not @user.valid?
  end

  # ----------------- Tests de validación de fortaleza de la contraseña ----------------- # TERMINAAAAAAAAAAAAAAR
  test 'is valid with a strong password' do # Happy path de la contraseña
    @user.password = 'StrongPass1!'
    assert @user.valid?
  end

  test 'is invalid if blank' do
    @user.password = nil 
    @user.validate_password_strength
    assert_includes @user.errors[:password], 'no puede estar en blanco'
  end

  test 'is not valid with a password missing a lowercase letter' do
    @user.password = 'PASSWORD1!'
    @user.validate_password_strength
    assert_includes @user.errors[:password], 'no es válido incluir como minimo una mayuscula, minuscula y un simbolo'
  end
  
  test 'is not valid with a password missing an uppercase letter' do
    @user.password = 'password1!'
    @user.validate_password_strength
    assert_includes @user.errors[:password], 'no es válido incluir como minimo una mayuscula, minuscula y un simbolo'
  end
  
  test 'is not valid with a password missing a number' do
    @user.password = 'Password!'
    @user.validate_password_strength
    assert_includes @user.errors[:password], 'no es válido incluir como minimo una mayuscula, minuscula y un simbolo'
  end
  
  test 'is not valid with a password missing a special character' do
    @user.password = 'Password1'
    @user.validate_password_strength
    assert_includes @user.errors[:password], 'no es válido incluir como minimo una mayuscula, minuscula y un simbolo'
  end
end
