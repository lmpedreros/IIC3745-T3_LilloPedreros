require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com')
    @product = Product.create!(nombre: 'Test Product', categories: 'Accesorio deportivo', stock: 10, precio: 100,
                               user: @user)
    @message = Message.new(body: 'Body message', user: @user, product: @product)
  end

  # Happy path test
  test 'should be valid with valid attributes' do
    assert @message.valid?
  end

  # Alternative path tests for validations
  test 'should be invalid without a body' do
    # @message.body = ""
    @message.body = nil
    assert_not @message.valid?
  end

  # Camino alternativo: user no presente
  test 'should be invalid without a user' do
    @message.user = nil
    assert_not @message.valid?
  end

  # Camino alternativo: product no presente
  test 'should be invalid without a product' do
    @message.product = nil
    assert_not @message.valid?
  end
end
