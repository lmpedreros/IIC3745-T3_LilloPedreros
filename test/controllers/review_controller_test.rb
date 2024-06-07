require 'test_helper'

class ReviewControllerTest < ActionDispatch::IntegrationTest
#   setup do
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com')
    @user2 = User.create!(name: 'John2', password: 'Sisisi123!', email: 'hola@gmail.com')
    @product = Product.create!(nombre: 'Product Test', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
    # @review = Review.create!(tittle: 'Review Title', description: 'Review description', calification: 4, product: @product, user: @user)
    @review = Review.create!(tittle: 'Review Title', description: 'Review description', calification: 4, product_id: @product.id, user_id: @user.id)
    sign_in @user
  end

  # Test para insertar una nueva reseña (happy path)
  test 'should insert review' do
    assert_difference('Review.count', 1) do
      post '/reviews/insertar', params: {
        product_id: @product.id,
        tittle: 'With great power comes great responsibility',
        description: 'I love this product!',
        calification: 5
      }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_select 'div.notice', 'Review creado Correctamente !'
  end

  # Test para insertar una nueva reseña (camino alternativo: datos incompletos)
  test 'should not insert review with incomplete data' do
    assert_no_difference('Review.count') do
      post '/reviews/insertar', params: {
        product_id: @product.id,
        tittle: '',
        description: 'I love this product!',
        calification: 5
      }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_select 'div.error', 'Hubo un error al guardar la reseña; debe completar todos los campos solicitados.'
  end

  # Test para actualizar una reseña existente (happy path)
  test 'should update review' do
    patch '/reviews/actualizar_review', params: {
      id: @review.id,
      tittle: 'Updated Title',
      description: 'Updated description',
      calification: 4
    }
    assert_redirected_to "/products/leer/#{@review.product.id}"
    @review.reload
    assert_equal 'Updated Title', @review.tittle
    assert_equal 'Updated description', @review.description
    assert_equal 4, @review.calification
  end

  # Test para actualizar una reseña existente (camino alternativo: datos incompletos)
  test 'should not update review with incomplete data' do
    patch '/reviews/actualizar_review', params: {
      id: @review.id,
      tittle: '',
      description: 'Updated description',
      calification: 4
    }
    assert_redirected_to "/products/leer/#{@review.product.id}"
    @review.reload
    refute_equal '', @review.tittle
  end

  # Test para eliminar una reseña (happy path para dueño de la reseña)
  test 'user should delete own review' do
    assert_difference('Review.count', -1) do
      delete '/reviews/eliminar', params: { id: @review.id }
    end
    assert_redirected_to "/products/leer/#{@review.product.id}"
  end

  # Test para eliminar una reseña (camino alternativo: usuario no es el dueño)
  test 'user should not delete review if not owner' do
    sign_out @user
    sign_in @user2
    assert_no_difference('Review.count') do
      delete '/reviews/eliminar', params: { id: @review.id }
    end
    assert_redirected_to root_path
  end

  # Test para eliminar una reseña (camino alternativo: reseña inexistente)
  test 'should not delete non-existent review' do
    assert_no_difference('Review.count') do
      delete '/reviews/eliminar', params: { id: 9999 }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
  end

  # Test para eliminar una reseña (camino alternativo: sin autorización)
  test 'should not delete review if not logged in' do
    sign_out @user
    assert_no_difference('Review.count') do
      delete '/reviews/eliminar', params: { id: @review.id }
    end
    assert_redirected_to new_user_session_path
  end
end
