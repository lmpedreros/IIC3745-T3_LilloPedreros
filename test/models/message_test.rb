require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Test User", email: "user@test.com", password: "password")
    @product = Product.create!(nombre: "Test Product", categories: "Accesorio deportivo", stock: 10, precio: 100.0, user: @user)
    @message = Message.new(body: "This is a test message", user: @user, product: @product)
  end

  # Happy path test
  test "should be valid with valid attributes" do
    assert @message.valid?
  end

  # Alternative path tests for validations
  test "should be invalid without a body" do
    @message.body = ""
    assert_not @message.valid?
  end

  test "should be invalid without a user" do
    @message.user = nil
    assert_not @message.valid?
  end

  test "should be invalid without a product" do
    @message.product = nil
    assert_not @message.valid?
  end
end
