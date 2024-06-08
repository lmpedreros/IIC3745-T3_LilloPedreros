require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com',
                         role: 'admin')
    @product = Product.new(nombre: 'Producto1', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
  end

  # Happy Path
  test 'is valid with valid attributes' do
    assert @product.valid?
  end

  # ----------------- Tests de validación de atributos ----------------- #
  test 'is not valid without categories' do
    @product.categories = nil
    assert_not @product.valid?
    # assert_includes @product.errors[:categories], "no puede estar en blanco"
  end

  test 'is not valid with an invalid category' do
    @product.categories = 'Invalid Category'
    assert_not @product.valid?
    # assert_includes @product.errors[:categories], 'is not included in the list'
  end

  test 'is not valid without a name' do
    @product.nombre = nil
    assert_not @product.valid?
    # assert_includes @product.errors[:nombre], "can't be blank"
  end

  test 'is not valid without stock' do
    @product.stock = nil
    assert_not @product.valid?
    # assert_includes @product.errors[:stock], "can't be blank"
  end

  test 'is not valid with negative stock' do
    @product.stock = -1
    assert_not @product.valid?
    # assert_includes @product.errors[:stock], 'must be greater than or equal to 0'
  end

  test 'is not valid without a price' do
    @product.precio = nil
    assert_not @product.valid?
    # assert_includes @product.errors[:precio], "can't be blank"
  end

  test 'is not valid with negative price' do
    @product.precio = -1
    assert_not @product.valid?
    # assert_includes @product.errors[:precio], 'must be greater than or equal to 0'
  end

  # ----------------- Tests de asociaciones ----------------- #
  test 'destroys associated reviews when product is destroyed' do
    @product.save
    @product.reviews.create!(tittle: 'Great!', description: 'Loved it', calification: 5, user: @user)
    assert_difference('Review.count', -1) do
      @product.destroy
    end
  end

  test 'destroys associated messages when product is destroyed' do
    @product.save
    @product.messages.create!(body: 'Sample message', user: @user)
    assert_difference('Message.count', -1) do
      @product.destroy
    end
  end

  test 'destroys associated solicituds when product is destroyed' do
    @product.save
    @product.solicituds.create!(stock: 1, status: 'pending', user: @user)
    assert_difference('Solicitud.count', -1) do
      @product.destroy
    end
  end
end
