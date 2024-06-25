require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com', role: 'admin')
    @user2 = User.create!(name: 'John2', password: 'Sisisi123!', email: 'hola@gmail.com', role: 'user')
    @product = Product.create!(nombre: 'Product1', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
    sign_in @user
  end

  # ----------------- Tests para GET /users/show ----------------- #
  test 'should show user' do
    sign_in @user
    get '/users/show'
    assert_response :success
  end

  test 'should show deseados' do
    sign_in @user
    get '/users/deseados'
    assert_response :success
  end

  test 'should show mensajes' do
    sign_in @user
    @message = Message.create!(user: @user, product: @product, body: 'Hola')
    get '/users/mensajes'
    assert_response :success
  end

  # ----------------- Test para patch -------------------------------- #

  test 'should update user image' do
    sign_in @user
    image = fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.jpg'), 'image/jpg')
    patch '/users/actualizar_imagen', params: { image: image }
    assert_redirected_to '/users/show'
    follow_redirect!
    assert_match 'Imagen actualizada correctamente', flash[:notice]
  end

  test 'should not update user image with invalid file type' do
    sign_in @user
    image = fixture_file_upload(Rails.root.join('test/fixtures/users.yml'), 'text/yml')
    patch '/users/actualizar_imagen', params: { image: image }
    assert_redirected_to '/users/show'
    follow_redirect!
    assert_match 'Hubo un error al actualizar la imagen. Verifique que la imagen es de formato jpg, jpeg, png, gif o webp', flash[:error]
  end

  # ----------------- Tests para DELETE /users/eliminar_deseado ----------------- #

  test 'should delete an existing product from deseado' do
    sign_in @user
    @user.deseados << @product.id.to_s
    @user.save
    assert_difference('@user.deseados.count', -1) do
      delete "/users/eliminar_deseado/#{@product[:id]}", params: {deseado_id: @product[:id]}
    end
    assert_redirected_to '/users/deseados'
    follow_redirect!
    assert_match 'Producto quitado de la lista de deseados', flash[:notice]
  end

  test 'should not delete deseado if failed to save' do
    sign_in @user
    @user.deseados << @product.id.to_s
    @user.save
    User.any_instance.stubs(:save).returns(false)
    delete "/users/eliminar_deseado/#{@product[:id]}", params: {deseado_id: @product[:id]}
    assert_redirected_to '/users/deseados'
    follow_redirect!
    assert_match 'Hubo un error al quitar el producto de la lista de deseados', flash[:error]
   end
end
