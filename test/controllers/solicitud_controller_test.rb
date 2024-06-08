require 'test_helper'

class SolicitudControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com', role: 'admin')
    @product = Product.create!(nombre: 'Product1', precio: 2000, stock: 10, user: @user, categories: 'Cancha')
    @solicitud = Solicitud.create!(user: @user, product: @product, stock: 5, status: 'Pendiente')
    sign_in @user
  end

  # READ
  test "should get index" do
    get solicitud_index_url
    assert_response :success
    assert_not_nil assigns(:solicitudes)
    assert_not_nil assigns(:productos)
  end

  test "should not get index when not signed in" do
    sign_out @user
    assert_raises(NoMethodError) do
      get solicitud_index_url
    end
  end

  # CREATE
  test "should create solicitud with valid attributes" do
    assert_difference('Solicitud.count') do
      post solicitud_insertar_url, params: { 
        solicitud: { 
          stock: 3, 
          reservation_datetime: 1.day.from_now 
        }, 
        product_id: @product.id 
      }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_match 'Solicitud de compra creada correctamente!', flash[:notice]
  end

  test "should not create solicitud with insufficient stock" do
    assert_no_difference('Solicitud.count') do
      post solicitud_insertar_url, params: { 
        solicitud: { 
          stock: 15, 
          reservation_datetime: 1.day.from_now 
        }, 
        product_id: @product.id 
      }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_match 'No hay suficiente stock para realizar la solicitud!', flash[:error]
  end

  test "should set flash error when solicitud save fails" do
    Solicitud.any_instance.stubs(:save).returns(false)
    post solicitud_insertar_url, params: {
      solicitud: {
        stock: 3,
        reservation_datetime: 1.day.from_now
      },
      product_id: @product.id
    }
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_match 'Hubo un error al guardar la solicitud!', flash[:error]
  end

  test "should create solicitud with reservation info" do
    assert_difference('Solicitud.count') do
      post solicitud_insertar_url, params: {
        solicitud: {
          stock: 2,
          reservation_datetime: 1.day.from_now
        },
        product_id: @product.id
      }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    #assert_match 'Solicitud de compra creada correctamente!', flash[:notice]
    solicitud = Solicitud.last
    assert_match 'Solicitud de reserva para el día', solicitud.reservation_info
  end

  test "should handle missing reservation_datetime" do
    assert_difference('Solicitud.count') do
      post solicitud_insertar_url, params: {
        solicitud: {
          stock: 3
        },
        product_id: @product.id
      }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_match 'Solicitud de compra creada correctamente!', flash[:notice]
  end

  # UPDATE
  test "should update solicitud to approved" do
    patch url_for(controller: 'solicitud', action: 'actualizar', id: @solicitud.id), params: { solicitud: { status: 'Aprobada' } }
    assert_redirected_to '/solicitud/index'
    @solicitud.reload
    assert_equal 'Aprobada', @solicitud.status
  end

  test "should set flash error when solicitud update fails" do
    Solicitud.any_instance.stubs(:update).returns(false)
    patch url_for(controller: 'solicitud', action: 'actualizar', id: @solicitud.id), params: { solicitud: { status: 'Rechazado' } }
    assert_redirected_to '/solicitud/index'
    assert_match 'Hubo un error al aprobar la solicitud!', flash[:error]
    end

  # DELETE
  test "should destroy solicitud" do
    assert_difference('Solicitud.count', -1) do
      delete url_for(controller: 'solicitud', action: 'eliminar', id: @solicitud.id)
    end
    assert_redirected_to '/solicitud/index'
    follow_redirect!
    assert_match 'Solicitud eliminada correctamente!', flash[:notice]
    @product.reload
    assert_equal 15, @product.stock.to_i
  end

  test "should raise error when trying to delete non-existent solicitud" do
    assert_raises(ActiveRecord::RecordNotFound) do
      delete url_for(controller: 'solicitud', action: 'eliminar', id: -1)
    end
  end

  test "should set flash error when solicitud deletion fails" do
    Solicitud.any_instance.stubs(:destroy).returns(false)
    delete url_for(controller: 'solicitud', action: 'eliminar', id: @solicitud.id)
    assert_redirected_to "/solicitud/index"
    follow_redirect!
    assert_match 'Hubo un error al eliminar la solicitud!', flash[:error]
  end

#   # PARAMETERS
#   test "should handle parameter validation" do
#     params = {
#       solicitud: {
#         stock: 5,
#         reservation_datetime: 1.day.from_now
#       },
#       product_id: @product.id
#     }
#     @controller.instance_eval { def parametros(params); params.require(:solicitud).permit(:stock, :reservation_datetime).merge(product_id: params[:product_id]) end }
#     permitted_params = @controller.send(:parametros, params)
#     assert_equal params.with_indifferent_access, permitted_params.with_indifferent_access
#   end

end