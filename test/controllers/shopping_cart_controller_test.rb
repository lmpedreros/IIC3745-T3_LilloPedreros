require 'test_helper'

class ShoppingCartControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_admin = User.create!(name: 'Admin', email: 'admin@example.com', password: 'password', role: 'admin')
    @user_non_admin = User.create!(name: 'User', email: 'user@example.com', password: 'password', role: 'user')
    sign_in @user_admin
    @product1 = Product.create!(nombre: 'Product1', precio: 1000, stock: 200, user_id: @user_admin.id, categories: 'Cancha')
    @product2 = Product.create!(nombre: 'Product2', precio: 2000, stock: 5, user_id: @user_admin.id, categories: 'Accesorio tecnologico')
    @product3 = Product.create!(nombre: 'Product3', precio: 1000, stock: 200, user_id: @user_admin.id, categories: 'Cancha')
    @product4 = Product.create!(nombre: 'Product4', precio: 1000, stock: 200, user_id: @user_admin.id, categories: 'Cancha')
    @product5 = Product.create!(nombre: 'Product5', precio: 1000, stock: 200, user_id: @user_admin.id, categories: 'Cancha')
    @product6 = Product.create!(nombre: 'Product6', precio: 1000, stock: 200, user_id: @user_admin.id, categories: 'Cancha')
    @product7 = Product.create!(nombre: 'Product7', precio: 1000, stock: 200, user_id: @user_admin.id, categories: 'Cancha')
    @product8 = Product.create!(nombre: 'Product8', precio: 1000, stock: 200, user_id: @user_admin.id, categories: 'Cancha')
    @product9 = Product.create!(nombre: 'Product9', precio: 1000, stock: 200, user_id: @user_admin.id, categories: 'Cancha')
    # @shopping_cart = ShoppingCart.new(user: @user, products: {@product1.id => 2, @product2.id => 1})
  end

  teardown do
    sign_out @user_admin
  end

  # SHOW
  test "should show shopping cart" do
    @shopping_cart = ShoppingCart.new(user: @user_admin, products: {@product1.id => 2, @product2.id => 1})
    get carro_url
    assert_response :success
    assert_not_nil assigns(:shopping_cart)
  end

  test "should create shopping cart if none exists" do
    @shopping_cart = ShoppingCart.new(user: @user_admin, products: {@product1.id => 2, @product2.id => 1})
    assert_difference('ShoppingCart.count') do
      get carro_url
    end
  end

  # DETAILS
  test "should show shopping cart details" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: {@product1.id => 2, @product2.id => 1})
    get carro_detalle_url
    assert_response :success
  end

  test "should redirect to shopping cart if empty" do
    @shopping_cart = ShoppingCart.new(user: @user_admin, products: {})
    get carro_detalle_url
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'No tienes productos que comprar.', flash[:alert]
  end

  test "should calculate total price if products in cart" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product1.id => 2 })
    get carro_detalle_url
    assert_response :success
    assert_not_nil assigns(:total_pago)
  end

  test "should redirect to root if user is not signed in" do
    sign_out @user_admin
    get carro_detalle_url
    assert_redirected_to root_path
    follow_redirect!
    assert_match 'Debes iniciar sesión para comprar.', flash[:alert]
    end

  # INSERTAR_PRODUCTO
  test "should insert product into shopping cart" do
    @shopping_cart = ShoppingCart.new(user: @user_admin, products: {@product1.id => 2})
    assert_difference('ShoppingCart.count') do
      post carro_insertar_producto_url, params: { product_id: @product2.id, add: { amount: 1 } }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_match 'Producto agregado al carro de compras', flash[:notice]
  end

  test "should not insert product with insufficient stock" do
    @shopping_cart = ShoppingCart.new(user: @user_admin, products: {@product1.id => 2})
    post carro_insertar_producto_url, params: { product_id: @product2.id, add: { amount: 6 } }
    assert_redirected_to root_path
    follow_redirect!
    assert_match "El producto '#{@product2.nombre}' no tiene suficiente stock para agregarlo al carro de compras.", flash[:alert]
  end

  test "should not insert more than 100 units of product" do
    @shopping_cart = ShoppingCart.new(user: @user_admin, products: {@product1.id => 2})
    post carro_insertar_producto_url, params: { product_id: @product1.id, add: { amount: 101 } }
    assert_redirected_to root_path
    follow_redirect!
    assert_match "El producto '#{@product1.nombre}' tiene un máximo de 100 unidades por compra.", flash[:alert]
  end

  test "should not insert more than 8 products in cart" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: {@product1.id => 1, @product2.id => 1, @product3.id => 1, @product4.id => 1, @product5.id => 1, @product6.id => 1, @product7.id => 1, @product8.id => 1})
    post carro_insertar_producto_url, params: { product_id: @product9.id, add: { amount: 1 } }
    assert_redirected_to root_path
    follow_redirect!
    assert_match 'Has alcanzado el máximo de productos en el carro de compras (8). Elimina productos para agregar más o realiza el pago de los productos actuales.', flash[:alert]
  end

  test "should not insert product if update fails" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: {@product1.id => 1})
    Product.stubs(:find).returns(@product1)
    ShoppingCart.any_instance.stubs(:update).returns(false)
    post carro_insertar_producto_url, params: { product_id: @product1.id, add: { amount: 1 } }
    assert_response :unprocessable_entity
    assert_match 'Hubo un error al agregar el producto al carro de compras', flash[:alert]
  end

  test "should not insert product if user is not signed in" do
    sign_out @user_admin
    post carro_insertar_producto_url, params: { product_id: @product1.id, add: { amount: 1 } }
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'Debes iniciar sesión para agregar productos al carro de compras.', flash[:alert]
  end

  test "should redirect to carrito details if buy now" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: {@product1.id => 1})
    post carro_insertar_producto_url, params: { product_id: @product1.id, add: { amount: 1 }, buy_now: true }
    assert_redirected_to '/carro/detalle'
  end

  # ELIMINAR_PRODUCTO
  test "should delete product from shopping cart" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product1.id => 1 })
    delete "/carro/eliminar_producto/#{@product1.id}"
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'Producto eliminado del carro de compras', flash[:notice]
  end

  test "should not delete non-existent product from shopping cart" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: {@product1.id => 2})
    delete "/carro/eliminar_producto/#{@product9.id}"
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'El producto no existe en el carro de compras', flash[:alert]
  end

  test "should show error if failed to delete product from shopping cart" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: {@product1.id => 1})
    ShoppingCart.any_instance.stubs(:update).returns(false)
    delete "/carro/eliminar_producto/#{@product1.id}"
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'Hubo un error al eliminar el producto del carro de compras', flash[:alert]
  end

  # COMPRAR_AHORA
  test "should buy now" do
    post carro_comprar_ahora_url, params: { product_id: @product1.id, add: { amount: 1 }, buy_now: true}
    assert_redirected_to '/carro/detalle'
  end

  # REALIZAR_COMPRA
  test "should complete purchase" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product1.id => 1 })
    assert_difference('Solicitud.count') do
      post carro_realizar_compra_url
    end
    assert_redirected_to '/solicitud/index'
    follow_redirect!
    assert_match 'Compra realizada exitosamente', flash[:notice]
  end

  test "should not complete purchase if cart is empty" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: {})
    post carro_realizar_compra_url
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'No tienes productos en el carro de compras', flash[:alert]
  end

  test "should not complete purchase if cart is not found" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product1.id => 1 })
    ShoppingCart.stubs(:find_by).returns(nil)
    post carro_realizar_compra_url
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'No se encontró tu carro de compras. Contacte un administrador.', flash[:alert]
  end

  test "should not complete purchase if failed to update cart" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product1.id => 1 })
    ShoppingCart.any_instance.stubs(:update).returns(false)
    post carro_realizar_compra_url
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'Hubo un error al actualizar el carro. Contacte un administrador.', flash[:alert]
  end

  test "shoukd not complete purchase if stock is not enough" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product2.id => 6 })
    post carro_realizar_compra_url
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match "Compra cancelada: El producto '#{@product2.nombre}' no tiene suficiente stock para realizar la compra. Por favor, elimina el producto del carro de compras o reduce la cantidad.", flash[:alert]
  end

  test "should not complete purchase if failed to create solicitud" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product1.id => 1 })
    Solicitud.any_instance.stubs(:save).returns(false)
    post carro_realizar_compra_url
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'Hubo un error al realizar la compra. Contacte un administrador.', flash[:alert]
  end

  # LIMPIAR
  test "should clean shopping cart" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product1.id => 1 })
    delete carro_limpiar_url
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'Carro de compras limpiado exitosamente', flash[:notice]
  end

  test "should show error if failed to clean shopping cart" do
    @shopping_cart = ShoppingCart.create!(user: @user_admin, products: { @product1.id => 1 })
    ShoppingCart.any_instance.stubs(:update).returns(false)
    delete carro_limpiar_url
    assert_redirected_to '/carro'
    follow_redirect!
    assert_match 'Hubo un error al limpiar el carro de compras. Contacte un administrador.', flash[:alert]
  end

  # PRIVATE FUNCTIONS

  test "should show error if failed to create shopping cart" do
    ShoppingCart.any_instance.stubs(:save).returns(false)
    post carro_insertar_producto_url, params: { product_id: @product1.id, add: { amount: 1 } }
    assert_redirected_to :root
    follow_redirect!
    assert_match 'Hubo un error al crear el carro. Contacte un administrador.', flash[:alert]
  end

end