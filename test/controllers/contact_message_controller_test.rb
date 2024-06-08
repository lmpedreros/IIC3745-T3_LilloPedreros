require 'test_helper'

class ContactMessageControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_admin = User.create!(name: 'Admin', email: 'admin@example.com', password: 'password', role: 'admin')
    @user_non_admin = User.create!(name: 'User', email: 'user@example.com', password: 'password', role: 'user')
    @contact_message = ContactMessage.create!(name: 'John Doe', mail: 'john@example.com', phone: '+56998765432',
                                              title: 'Test', body: 'This is a test message.')
    sign_in @user_admin
  end

  teardown do
    sign_out @user_admin
  end

  # READ
  test 'should get mostrar' do
    get contacto_url
    assert_response :success
    assert_not_nil assigns(:contact_messages)
  end

  # CREATE
  test 'should create contact message with valid attributes' do
    assert_difference('ContactMessage.count') do
      post contacto_crear_url,
           params: { contact: { name: 'Joe', mail: 'joe@example.com', phone: '+56998765432', title: 'Hello',
                                body: 'This is another test message.' } }
    end
    assert_redirected_to '/contacto'
    follow_redirect!
    assert_match 'Mensaje de contacto enviado correctamente', flash[:notice]
  end

  test 'should not create contact message with invalid attributes' do
    assert_no_difference('ContactMessage.count') do
      post contacto_crear_url, params: { contact: { name: '', mail: '', phone: '', title: '', body: '' } }
    end
    assert_redirected_to '/contacto'
    follow_redirect!
    assert_match 'Error al enviar el mensaje de contacto', flash[:alert]
  end

  # DELETE
  test 'should delete contact message as admin' do
    assert_difference('ContactMessage.count', -1) do
      delete url_for(controller: 'contact_message', action: 'eliminar', id: @contact_message.id)
    end
    assert_redirected_to '/contacto'
    follow_redirect!
    assert_match 'Mensaje de contacto eliminado correctamente', flash[:notice]
  end

  test 'should not delete contact message as non-admin' do
    sign_out @user_admin
    sign_in @user_non_admin
    assert_no_difference('ContactMessage.count') do
      delete url_for(controller: 'contact_message', action: 'eliminar', id: @contact_message.id)
    end
    assert_redirected_to '/contacto'
    follow_redirect!
    assert_match 'Debes ser un administrador para eliminar un mensaje de contacto.', flash[:alert]
  end

  test 'should raise error when trying to delete non-existent contact message' do
    assert_no_difference('ContactMessage.count') do
      delete url_for(controller: 'contact_message', action: 'eliminar', id: -1)
    end
    assert_redirected_to '/contacto'
    follow_redirect!
    assert_match 'Error al eliminar el mensaje de contacto', flash[:alert]
  end

  # DELETE ALL
  test 'should delete all contact messages as admin' do
    ContactMessage.create!(name: 'Jane Doe', mail: 'jane@example.com', phone: '+56998765432', title: 'Hello',
                           body: 'This is another test message.')
    assert_difference('ContactMessage.count', -ContactMessage.count) do
      delete contacto_limpiar_url
    end
    assert_redirected_to '/contacto'
    follow_redirect!
    assert_match 'Mensajes de contacto eliminados correctamente', flash[:notice]
  end

  test 'should not delete all contact messages as non-admin' do
    sign_out @user_admin
    sign_in @user_non_admin
    assert_no_difference('ContactMessage.count') do
      delete contacto_limpiar_url
    end
    assert_redirected_to '/contacto'
    follow_redirect!
    assert_match 'Debes ser un administrador para eliminar los mensajes de contacto.', flash[:alert]
  end

  test 'should raise error when trying to delete all non-existent contact messages' do
    delete url_for(controller: 'contact_message', action: 'eliminar', id: @contact_message.id)
    assert_no_difference('ContactMessage.count') do
      delete contacto_limpiar_url
    end
    assert_redirected_to '/contacto'
    follow_redirect!
    assert_match 'Error al eliminar los mensajes de contacto', flash[:alert]
  end
end
