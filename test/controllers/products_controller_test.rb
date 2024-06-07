require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com',
                         role: 'admin')
    @other_user = User.create!(name: 'John2', password: 'Sisisi123!', email: 'hola@gmail.com', role: 'user') # No loggeado
    sign_in @user
    @product = Product.create!(nombre: 'John1', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
  end

  # ----------------- Tests para GET /products/index ----------------- #
  test 'should get index' do
    get '/products/index'
    assert_response :success
  end

  test 'should get index with user logout' do
    sign_out @user
    get '/products/index'
    assert_response :success
  end

  # ----------------- # Tests para GET /products/leer/:id ----------------- #
  test 'should get leer' do
    get "/products/leer/#{@product.id}"
    assert_response :success
  end

  test 'should not get leer with invalid id' do
    get '/products/leer/9999'
    assert_response :missing
  end

  # ----------------- # Tests para GET /products/crear ----------------- #
  test 'should get new' do  # ES GET O POST?
    get '/products/crear'
    assert_response :success
  end

  test 'should not get new if not logged in' do  # NECESARIO??????
    sign_out @user
    get '/products/crear'
    assert_redirected_to new_user_session_path    # WHAT???????
  end

  # ----------------- # Tests para POST /products/insertar ----------------- #
  test 'should insertar product' do
    assert_difference('Product.count', 1) do
      post '/products/insertar', params: { product: { nombre: 'Product Test', precio: 5000, stock: 10, categories: 'Suplementos' } }
    end
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_select 'div.notice', 'Producto creado Correctamente !'
  end

  test 'should not insertar product with invalid data' do
    assert_no_difference('Product.count') do
      post '/products/insertar', params: { product: { nombre: '', precio: "hola", stock: 10, categories: 'Suplementos' } }
    end
    assert_redirected_to '/products/crear'
    follow_redirect!
    assert_select 'div.error', /Hubo un error al guardar el producto:/
  end

  test 'should not allow non-admin to insertar product' do   # REVISAAAAAAAAAAAAAAAAAAAAAAAAR
    sign_out @user
    sign_in @other_user
    post '/products/insertar', params: { product: { nombre: 'Product Test', precio: 5000, stock: 10, categories: 'Suplementos' } }
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_select 'div.alert', 'Debes ser un administrador para crear un producto.'
  end

  # ----------------- # Tests para POST /products/actualizar ----------------- #
  test 'should get actualizar' do   # ES GET O PATCH??????
    get "/products/actualizar/#{@product.id}"
    assert_response :success
  end

  test 'should not get actualizar with invalid id' do
    get '/products/actualizar/9999'
    assert_response :missing
  end

  test 'should not get edit if not logged in' do   # REVISAAAAAAAAAAAAAAAAAAAAAAAARRRRR
    sign_out @user
    get "/products/actualizar/#{@product.id}"
    assert_redirected_to new_user_session_path  # WHAAAAT?
  end

  # ----------------- # Tests para PATCH /products/actualizar_producto/:id ----------------- #
  test 'should update product' do
    patch "/products/actualizar_producto/#{@product.id}", params: { product: { nombre: 'Updated Product' } }
    assert_redirected_to '/products/index'
    @product.reload
    assert_equal 'Updated Product', @product.nombre
  end

  test 'should not update product with invalid data' do
    patch "/products/actualizar_producto/#{@product.id}", params: { product: { nombre: '' } }
    assert_redirected_to "/products/actualizar/#{@product.id}"
    follow_redirect!
    assert_select 'div.error', 'Hubo un error al guardar el producto. Complete todos los campos solicitados!'
  end

  test 'should not allow non-admin to update product' do   # REVISAAAAAAAAAAAAAAAAAAAAAAAAR
    sign_out @user
    sign_in @other_user
    patch "/products/actualizar_producto/#{@product.id}", params: { product: { nombre: 'Updated Product' } }
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_select 'div.alert', 'Debes ser un administrador para modificar un producto.'
    @product.reload
    assert_not_equal 'Updated Product', @product.nombre
  end

  # ----------------- # Tests para DELETE /products/eliminar/:id ----------------- #
  test 'should destroy product' do
    assert_difference('Product.count', -1) do
      delete "/products/eliminar/#{@product.id}"
    end
    assert_redirected_to '/products/index'
  end

  test 'should not delete product with invalid id' do
    assert_no_difference('Product.count') do
      delete '/products/eliminar/9999'
    end
    assert_redirected_to '/products/index'
  end

  test 'should not allow non-admin to delete product' do
    sign_out @user
    sign_in @other_user
    assert_no_difference('Product.count') do
      delete "/products/eliminar/#{@product.id}"
    end
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_select 'div.alert', 'Debes ser un administrador para eliminar un producto.'
  end
end
