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
      post '/messages/insertar', params: { message: { body: 'New Message' }, product_id: @product.id }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_select 'div.notice', 'Pregunta creada correctamente!'
  end

  test 'should not insert message if not logged in' do  # REVISAR PQ PUEDE QUE DE PROBLEMAS
    sign_out @user
    post '/messages/insertar', params: { message: { body: 'New Message' }, product_id: @product.id }
    assert_redirected_to new_user_session_path
  end

  test 'should show error message if insertion fails' do
    # post '/messages/insertar', params: { message: { body: "" }, product_id: @product.id }
    post '/messages/insertar', params: { message: { body: nil }, product_id: @product.id }
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_select 'div.error', 'Hubo un error al guardar la pregunta. ¡Completa todos los campos solicitados!'
  end

  test 'should insert message with ancestry' do
    parent_message = Message.create!(body: 'Parent Message', product_id: @product.id, user_id: @user.id)
    assert_difference('Message.count', 1) do
      post '/messages/insertar', params: { message: { body: 'Child Message' }, product_id: @product.id, ancestry: parent_message.id }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_select 'div.notice', 'Pregunta creada correctamente!'
  end
  
  # ----------------- # Tests para DELETE /messages/eliminar ----------------- #
  test 'should delete message' do
    assert_difference('Message.count', -1) do
      delete '/messages/eliminar', params: { message_id: @message.id, product_id: @product.id }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
  end

  test 'should not delete message if not logged in' do
    sign_out @user
    assert_no_difference('Message.count') do
      delete '/messages/eliminar', params: { message_id: @message.id, product_id: @product.id }
    end
    assert_redirected_to new_user_session_path
  end

  test 'should not delete non-existent message' do  # NO SÉ YO.....
    assert_no_difference('Message.count') do
      delete '/messages/eliminar', params: { message_id: 9999, product_id: @product.id }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
  end
end
