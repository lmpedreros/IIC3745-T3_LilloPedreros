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

  # test 'should redirect show when not authenticated' do
  #   sign_out @user
  #   get '/users/show'
  #   assert_redirected_to new_user_session_path
  # end

  # # ----------------- Tests para GET /users/deseados ----------------- #
  # test 'should get deseados' do
  #   get '/users/deseados'
  #   assert_response :success
  # end

  # test 'should not show desired products if not logged in' do
  #   sign_out @user
  #   get '/users/deseados'
  #   assert_redirected_to new_user_session_path
  # end

  # # ----------------- Tests para GET /users/mensajes ----------------- #
  # test 'should get mensajes' do
  #   get '/users/mensajes'
  #   assert_response :success
  # end

  # test 'should not show messages if not logged in' do
  #   sign_out @user
  #   get '/users/mensajes'
  #   assert_redirected_to new_user_session_path
  # end

  # # ----------------- Tests para PATCH /users/actualizar_imagen ----------------- # TERMINAAAAAAAAAAAAAAR
  # test 'should update user image' do
  #   image = fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.jpg'), 'image/jpg')
  #   patch '/users/actualizar_imagen', params: { image: }
  #   assert_redirected_to '/users/show'
  #   follow_redirect!
  #   assert_select 'div.notice', 'Imagen actualizada correctamente'
  # end

  # test 'should not update user image with invalid file type' do
  #   image = fixture_file_upload(Rails.root.join('test/fixtures/files/test_file.svg'), 'text/svg')
  #   patch '/users/actualizar_imagen', params: { image: }
  #   assert_redirected_to '/users/show'
  #   follow_redirect!
  #   assert_select 'div.error',
  #                 'Hubo un error al actualizar la imagen. Verifique que la ' \
  #                 'imagen es de formato jpg, jpeg, png, gif o webp'
  # end

  # test 'should not update user image if not logged in' do
  #   sign_out @user
  #   image = fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.jpg'), 'image/jpg')
  #   patch '/users/actualizar_imagen', params: { image: }
  #   assert_redirected_to new_user_session_path
  # end

  # # ----------------- Tests para DELETE /users/eliminar_deseado ----------------- #

  # test 'should delete an existing product from deseado' do
  #   @user.deseados << @product.id.to_s
  #   @user.save
  #   assert_difference('@user.deseados.count', -1) do
  #     delete "/users/eliminar_deseado/#{@product.id}"
  #   end
  #   assert_redirected_to '/users/deseados'
  #   follow_redirect!
  #   assert_select 'div.notice', 'Producto quitado de la lista de deseados'
  # end

  # test 'should not delete non-existent deseadppo' do
  #   @user.save
  #   assert_no_difference('@user.deseados.count') do
  #     delete '/users/eliminar_deseado/99999'
  #   end
  #   assert_redirected_to '/users/deseados'
  #   follow_redirect!
  #   assert_select 'div.error', 'Hubo un error al quitar el producto de la lista de deseados'
  # end
end
