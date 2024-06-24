require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com', role: 'admin')
    @other_user = User.create!(name: 'John2', password: 'Sisisi123!', email: 'hola@gmail.com', role: 'user')
    sign_in @user
    @product = Product.create!(nombre: 'cancha bacan', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
    @product2 = Product.create!(nombre: 'Product2', precio: 3000, stock: 15, user_id: @user.id, categories: 'Equipamiento')
  end

  # ----------------- Tests para GET /products/index ----------------- #
  test 'should get index' do
    get products_index_url
    assert_response :success
  end

  test 'should get index with user logout' do
    sign_out @user
    get '/products/index'
    assert_response :success
  end

  test 'should get index with category filter' do
    get products_index_url, params: { category: 'Cancha' }
    assert_response :success
    products = assigns(:products)
    assert_equal 1, products.count
  end

  test 'should get index with search filter' do
    get products_index_url, params: { search: 'Product2' }
    assert_response :success
    products = assigns(:products)
    assert_equal 1, products.count
  end

  test 'should get index with category and search filter' do
    get products_index_url, params: { category: 'Cancha', search: 'cancha bacan' }
    assert_response :success
    products = assigns(:products)
    assert_equal 1, products.count
  end

  # ----------------- # Tests para GET /products/leer/:id ----------------- #
  test 'should get leer with horarios' do
    @product.update(horarios: 'Monday,10:00-18:00;Tuesday,10:00-18:00')
    get "/products/leer/#{@product.id}"
    assert_response :success
    assert_equal [['Monday', '10:00-18:00'], ['Tuesday', '10:00-18:00']], assigns(:horarios)
  end

  # ----------------- # Tests para GET /products/crear ----------------- #
  test 'should get new' do 
    get '/products/crear'
    assert_response :success
  end


  # ----------------- # Tests para POST /products/insertar_deseado ----------------- #
  test 'should insert deseado when deseado is nil' do
    sign_in @user
    @user.deseados = nil
    post "/products/insert_deseado/#{@product.id}"
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_equal [@product.id.to_s], @user.reload.deseados
    assert_equal 'Producto agregado a la lista de deseados', flash[:notice]
  end

  test 'should insert deseado when deseado is not nil' do
    sign_in @user
    post "/products/insert_deseado/#{@product.id}"
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_equal [@product.id.to_s], @user.reload.deseados
    assert_equal 'Producto agregado a la lista de deseados', flash[:notice]
  end

  test 'should show error if failed to insert deseado' do
    sign_in @user
    User.any_instance.stubs(:save).returns(false)
    post "/products/insert_deseado/#{@product.id}"
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_match "Hubo un error al guardar los cambios: #{@user.errors.full_messages.join(', ')}", flash[:error]
  end

  # ----------------- # Tests para POST /products/insertar ----------------- #

  test 'should be an admin to create a product' do
    sign_out @user
    sign_in @other_user
    post '/products/insertar', params: { product: { nombre: 'Product Test', precio: 5000, stock: 10, categories: 'Cancha' } }
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_equal 'Debes ser un administrador para crear un producto.', flash[:alert]
  end

  test 'should create product' do
    sign_in @user
    post '/products/insertar', params: { product: { nombre: 'Product Test', precio: 5000, stock: 10, categories: 'Cancha' } }
    assert_redirected_to '/products/index' 
    follow_redirect!
    assert_equal 'Producto creado Correctamente !', flash[:notice]
  end

  test 'should show error if failed to create product' do
    sign_in @user
    Product.any_instance.stubs(:save).returns(false)
    post '/products/insertar', params: { product: { nombre: 'Product Test', precio: 5000, stock: 10, categories: 'Cancha' } }
    assert_redirected_to '/products/crear'
    follow_redirect!
    assert_match "Hubo un error al guardar el producto: ", flash[:error]
  end

  # ----------------- # Tests para get /products/actualizar ----------------- #

  test 'should update' do
    sign_in @user
    get "/products/actualizar/#{@product.id}"
    assert_response :success
    assert_equal @product, assigns(:product)
  end

  # ----------------- # Tests para post /products/actualizar ----------------- #

  test 'should not update if not admin' do
    @user.update(role: 'user')
    patch "/products/actualizar/#{@product.id}"
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_equal 'Debes ser un administrador para modificar un producto.', flash[:alert]
  end

  test 'should update product' do
    sign_in @user
    patch "/products/actualizar/#{@product.id}", params: { product: { nombre: 'Updated Product' } }
    assert_redirected_to '/products/index'
    @product.reload
    assert_equal 'Updated Product', @product.nombre
  end

  test 'should show error if failed to update product' do
    sign_in @user
    Product.any_instance.stubs(:update).returns(false)
    patch "/products/actualizar/#{@product.id}", params: { product: { nombre: 'Updated Product' } }
    assert_redirected_to "/products/actualizar/#{@product.id}"
    follow_redirect!
    assert_equal 'Hubo un error al guardar el producto. Complete todos los campos solicitados!', flash[:error]
  end

  # ----------------- # Tests para DELETE /products/eliminar/:id ----------------- #

  test 'should not delete product if not admin' do
    @user.update(role: 'user')
    delete "/products/eliminar/#{@product.id}", params: { id: @product.id }
    assert_redirected_to '/products/index'
    follow_redirect!
    assert_equal 'Debes ser un administrador para eliminar un producto.', flash[:alert]
  end

  test 'should delete product' do
    sign_in @user
    delete "/products/eliminar/#{@product.id}", params: { id: @product.id }
    assert_redirected_to '/products/index'
  end

  


  # test 'should destroy product' do
  #   assert_difference('Product.count', -1) do
  #     delete "/products/eliminar/#{@product.id}"
  #   end
  #   assert_redirected_to '/products/index'
  # end

  # test 'should not delete product with invalid id' do
  #   assert_no_difference('Product.count') do
  #     delete '/products/eliminar/9999'
  #   end
  #   assert_redirected_to '/products/index'
  # end

  # test 'should not allow non-admin to delete product' do
  #   sign_out @user
  #   sign_in @other_user
  #   assert_no_difference('Product.count') do
  #     delete "/products/eliminar/#{@product.id}"
  #   end
  #   assert_redirected_to '/products/index'
  #   follow_redirect!
  #   assert_select 'div.alert', 'Debes ser un administrador para eliminar un producto.'
  # end

  # # ------------------------------- EXTRAAAAAAAAAAAAAS ---------------------------- #
  # test 'should get index with category and search' do
  #   get '/products/index', params: { category: @product.categories, search: 'John' }
  #   assert_response :success
  #   assert_select 'div.product', count: 1
  # end

  # test 'should get index with category' do
  #   get '/products/index', params: { category: @product.categories }
  #   assert_response :success
  #   assert_select 'div.product', count: 1
  # end

  # test 'should get index with search' do
  #   get '/products/index', params: { search: 'John' }
  #   assert_response :success
  #   assert_select 'div.product', count: 1
  # end

  # test 'should calculate total califications' do
  #   @product.reviews.create!(calification: 4, comentario: 'Good')
  #   @product.reviews.create!(calification: 5, comentario: 'Excellent')

  #   get "/products/leer/#{@product.id}"
  #   assert_response :success
  #   assert_equal 4.5, assigns(:calification_mean)
  # end

  # test 'should process horarios' do
  #   @product.update(horarios: 'Lunes,9-12;Martes,10-13')

  #   get "/products/leer/#{@product.id}"
  #   assert_response :success
  #   assert_equal [%w[Lunes 9-12], %w[Martes 10-13]], assigns(:horarios)
  # end

  # test 'should insert product to existing wish list' do
  #   @user.update(deseados: [@product.id.to_s])
  #   new_product = Product.create!(nombre: 'Product Test 2', precio: 5000, stock: 10, categories: 'Suplementos')
  #   post '/products/insert_deseado', params: { product_id: new_product.id }
  #   assert_redirected_to "/products/leer/#{new_product.id}"
  #   follow_redirect!
  #   assert_select 'div.notice', 'Producto agregado a la lista de deseados'
  #   assert_includes @user.reload.deseados, new_product.id.to_s
  # end

  # test 'should update product successfully' do
  #   patch "/products/actualizar_producto/#{@product.id}", params: { product: { nombre: 'Updated Product' } }
  #   assert_redirected_to '/products/index'
  #   @product.reload
  #   assert_equal 'Updated Product', @product.nombre
  # end

  # test 'should fail to update product with invalid data' do
  #   patch "/products/actualizar_producto/#{@product.id}", params: { product: { nombre: '' } }
  #   assert_redirected_to "/products/actualizar/#{@product.id}"
  #   follow_redirect!
  #   assert_select 'div.error', 'Hubo un error al guardar el producto. Complete todos los campos solicitados!'
  # end

  # test 'should delete product as admin' do
  #   assert_difference('Product.count', -1) do
  #     delete "/products/eliminar/#{@product.id}"
  #   end
  #   assert_redirected_to '/products/index'
  # end

  # ---------------------- AHora se vienen unos mambos medios misticos --------------------------------- #

  # test 'should insert product to deseados?' do
  #   # @user.update(deseados: nil)
  #   # User.any_instance.stubs(:save).returns(false)
  #   post "/products/insert_deseado/#{@product.id}"
  #   assert_redirected_to "/products/leer/#{@product.id}"
  #   follow_redirect!
  #   assert_select 'div.error', /Hubo un error al guardar los cambios:/
  # end

  # test 'should insert product to deseados when deseados is empty?' do
  #   @user.deseados = nil
  #   # User.any_instance.stubs(:save).returns(false)
  #   post "/products/insert_deseado/#{@product.id}"
  #   assert_redirected_to "/products/leer/#{@product.id}"
  #   follow_redirect!
  #   assert_select 'div.error', /Hubo un error al guardar los cambios:/
  # end
end
