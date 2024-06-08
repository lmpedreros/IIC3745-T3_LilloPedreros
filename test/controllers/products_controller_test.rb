require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com', role: 'admin')
    @other_user = User.create!(name: 'John2', password: 'Sisisi123!', email: 'hola@gmail.com', role: 'user') # No loggeado
    # @user3 = User.create!(name: 'John33', password: 'dfgAAd2!', email: 'asdf@gmail.com', role: 'user', deseados: [])
    sign_in @user
    @product = Product.create!(nombre: 'John1', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
    # @other_product = Product.create!(nombre: 'John2', precio: 4000, stock: 1, user_id: @other_user.id, categories: 'Cancha')
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
  test 'should get new' do # ES GET O POST?
    get '/products/crear'
    assert_response :success
  end

  test 'should not get new if not logged in' do # NECESARIO??????
    sign_out @user
    get '/products/crear'
    assert_redirected_to new_user_session_path # WHAT???????
  end

  # ----------------- # Tests para POST /products/insertar ----------------- #
  test 'should insertar product' do
    assert_difference('Product.count', 1) do
      post '/products/insertar',
           params: { product: { nombre: 'Product Test', precio: 5000, stock: 10, categories: 'Suplementos' } }
    end
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_select 'div.notice', 'Producto creado Correctamente !'
  end

  test 'should not insertar product with invalid data' do
    assert_no_difference('Product.count') do
      post '/products/insertar',
           params: { product: { nombre: '', precio: 'hola', stock: 10, categories: 'Suplementos' } }
    end
    assert_redirected_to '/products/crear'
    follow_redirect!
    assert_select 'div.error', /Hubo un error al guardar el producto:/
  end

  test 'should not allow non-admin to insertar product' do # REVISAAAAAAAAAAAAAAAAAAAAAAAAR
    sign_out @user
    sign_in @other_user
    post '/products/insertar',
         params: { product: { nombre: 'Product Test', precio: 5000, stock: 10, categories: 'Suplementos' } }
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_select 'div.alert', 'Debes ser un administrador para crear un producto.'
  end

  # ----------------- # Tests para POST /products/actualizar ----------------- #
  test 'should update product' do
    patch "/products/actualizar/#{@product.id}", params: { product: { nombre: 'Updated Product' } }
    assert_redirected_to '/products/index'
    @product.reload
    assert_equal 'Updated Product', @product.nombre
  end

  test 'should not update product with invalid data' do
    patch "/products/actualizar/#{@product.id}", params: { product: { nombre: '' } }
    assert_redirected_to "/products/actualizar/#{@product.id}"
    follow_redirect!
    assert_select 'div.error', 'Hubo un error al guardar el producto. Complete todos los campos solicitados!'
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

  # ------------------------------- EXTRAAAAAAAAAAAAAS ---------------------------- #
  test 'should get index with category and search' do
    get '/products/index', params: { category: @product.categories, search: 'John' }
    assert_response :success
    assert_select 'div.product', count: 1
  end

  test 'should get index with category' do
    get '/products/index', params: { category: @product.categories }
    assert_response :success
    assert_select 'div.product', count: 1
  end

  test 'should get index with search' do
    get '/products/index', params: { search: 'John' }
    assert_response :success
    assert_select 'div.product', count: 1
  end

  test 'should calculate total califications' do
    review1 = @product.reviews.create!(calification: 4, comentario: 'Good')
    review2 = @product.reviews.create!(calification: 5, comentario: 'Excellent')

    get "/products/leer/#{@product.id}"
    assert_response :success
    assert_equal 4.5, assigns(:calification_mean)
  end

  test 'should process horarios' do
    @product.update(horarios: 'Lunes,9-12;Martes,10-13')

    get "/products/leer/#{@product.id}"
    assert_response :success
    assert_equal [%w[Lunes 9-12], %w[Martes 10-13]], assigns(:horarios)
  end

  test 'should insert product to existing wish list' do
    @user.update(deseados: [@product.id.to_s])
    new_product = Product.create!(nombre: 'Product Test 2', precio: 5000, stock: 10, categories: 'Suplementos')
    post '/products/insert_deseado', params: { product_id: new_product.id }
    assert_redirected_to "/products/leer/#{new_product.id}"
    follow_redirect!
    assert_select 'div.notice', 'Producto agregado a la lista de deseados'
    assert_includes @user.reload.deseados, new_product.id.to_s
  end

  test 'should update product successfully' do
    patch "/products/actualizar_producto/#{@product.id}", params: { product: { nombre: 'Updated Product' } }
    assert_redirected_to '/products/index'
    @product.reload
    assert_equal 'Updated Product', @product.nombre
  end

  test 'should fail to update product with invalid data' do
    patch "/products/actualizar_producto/#{@product.id}", params: { product: { nombre: '' } }
    assert_redirected_to "/products/actualizar/#{@product.id}"
    follow_redirect!
    assert_select 'div.error', 'Hubo un error al guardar el producto. Complete todos los campos solicitados!'
  end

  test 'should delete product as admin' do
    assert_difference('Product.count', -1) do
      delete "/products/eliminar/#{@product.id}"
    end
    assert_redirected_to '/products/index'
  end

  # ---------------------- AHora se vienen unos mambos medios misticos --------------------------------- #

  test 'should insert product to deseados?' do
    # @user.update(deseados: nil)
    # User.any_instance.stubs(:save).returns(false)
    post "/products/insert_deseado/#{@product.id}"
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_select 'div.error', /Hubo un error al guardar los cambios:/
  end

  test 'should insert product to deseados when deseados is empty?' do
    @user.deseados = nil
    # User.any_instance.stubs(:save).returns(false)
    post "/products/insert_deseado/#{@product.id}"
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_select 'div.error', /Hubo un error al guardar los cambios:/
  end
end
