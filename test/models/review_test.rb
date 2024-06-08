require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'Test User', email: 'user@test.com', password: 'password')
    @product = Product.create!(nombre: 'Test Product', categories: 'Accesorio deportivo', stock: 10, precio: 100.0,
                               user: @user)
    @review = Review.new(tittle: 'Great Product', description: 'This product is amazing!', calification: 5,
                         user: @user, product: @product)
  end

  # Happy path: instancia válida de Review
  test 'should be valid with valid attributes' do
    assert @review.valid?
  end

  # Camino alternativo: tittle no presente
  test 'should be invalid without a tittle' do
    @review.tittle = ''
    # @review.tittle = nil
    assert_not @review.valid?
  end

  # Camino alternativo: tittle demasiado largo
  test 'should be invalid if tittle is too long' do
    @review.tittle = 'A' * 200
    assert_not @review.valid?
  end

  # Camino alternativo: description no presente
  test 'should be invalid without a description' do
    @review.description = ''
    # @review.description = nil
    assert_not @review.valid?
  end

  # Camino alternativo: description demasiado larga
  test 'should be invalid if description is too long' do
    @review.description = 'A' * 600
    assert_not @review.valid?
  end

  # Camino alternativo: calification no presente
  test 'should be invalid without a calification' do
    @review.calification = nil
    assert_not @review.valid?
  end

  # Camino alternativo: calification no es un número entero
  test 'should be invalid if calification is not an integer' do
    @review.calification = 4.7
    assert_not @review.valid?
  end

  # Camino alternativo: calification menor que 1
  test 'should be invalid if calification is less than 1' do
    @review.calification = 0
    assert_not @review.valid?
  end

  # Camino alternativo: calification mayor que 5
  test 'should be invalid if calification is greater than 5' do
    @review.calification = 6
    assert_not @review.valid?
  end

  # Camino alternativo: user no presente
  test 'should be invalid without a user' do
    @review.user = nil
    assert_not @review.valid?
  end

  # Camino alternativo: product no presente
  test 'should be invalid without a product' do
    @review.product = nil
    assert_not @review.valid?
  end
end
