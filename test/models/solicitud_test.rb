require 'test_helper'

class SolicitudTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com', role: 'admin')
    @product = Product.create!(nombre: 'John1', precio: 4000, stock: 1, categories: 'Cancha', user: @user)
  end

  test 'should save solicitud with valid attributes' do
    solicitud = Solicitud.new(user: @user, product: @product, stock: 1, status: 'pending')
    assert solicitud.valid?, 'Solicitud should be valid with correct attributes'
    assert solicitud.save, 'Solicitud should save successfully with correct attributes'
  end

  test 'should not save solicitud without stock' do
    solicitud = Solicitud.new(user: @user, product: @product, status: 'pending')
    assert_not solicitud.valid?, 'Solicitud should be invalid without stock'
    assert solicitud.errors[:stock].any?, "No validation error for 'stock' present"
  end

  test 'should not save solicitud with non-integer stock' do
    solicitud = Solicitud.new(user: @user, product: @product, stock: 1.5, status: 'pending')
    assert_not solicitud.valid?, 'Solicitud should be invalid with non-integer stock'
    assert solicitud.errors[:stock].any?, "No validation error for 'stock' present"
  end

  test 'should not save solicitud with stock less than 1' do
    solicitud = Solicitud.new(user: @user, product: @product, stock: 0, status: 'pending')
    assert_not solicitud.valid?, 'Solicitud should be invalid with stock less than 1'
    assert solicitud.errors[:stock].any?, "No validation error for 'stock' present"
  end

  test 'should not save solicitud without status' do
    solicitud = Solicitud.new(user: @user, product: @product, stock: 1)
    assert_not solicitud.valid?, 'Solicitud should be invalid without status'
    assert solicitud.errors[:status].any?, "No validation error for 'status' present"
  end
end
