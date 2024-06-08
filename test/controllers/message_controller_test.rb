require 'test_helper'

class MessageControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com', role: 'admin')
    @other_user = User.create!(name: 'Jane', password: 'Nonono123!', email: 'jane@gmail.com', role: 'user')
    sign_in @user
    @product = Product.create!(nombre: 'Product Test', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
    @message = Message.create!(body: 'This is a test message', product_id: @product.id, user_id: @user.id)
  end

  # ----------------- # Tests para POST /messages/insertar ----------------- #
  test 'should insert message' do
    assert_difference('Message.count', 1) do
      post '/message/insertar', params: { message: { body: 'New Message' }, product_id: @product.id }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_match 'Pregunta creada correctamente!', flash[:notice]
  end

  test 'should show error message if insertion fails' do
    # post '/messages/insertar', params: { message: { body: "" }, product_id: @product.id }
    Message.any_instance.stubs(:save).returns(false)
    post '/message/insertar', params: { message: { body: 'New Message' }, product_id: @product.id }
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_match 'Hubo un error al guardar la pregunta. ¡Completa todos los campos solicitados!', flash[:error]
  end

  # ----------------- # Tests para DELETE /messages/eliminar ----------------- #
  test 'should delete message' do
    assert_difference('Message.count', -1) do
      delete '/message/eliminar', params: { message_id: @message.id, product_id: @product.id }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
  end

  test 'should not delete message if incorrect message id' do
    assert_no_difference('Message.count') do
      assert_raises(ActiveRecord::RecordNotFound) do
        delete '/message/eliminar', params: { message_id: 9999, product_id: @product.id }
      end
    end
  end
end
