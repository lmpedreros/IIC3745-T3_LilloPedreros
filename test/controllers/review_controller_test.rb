require 'test_helper'

class ReviewControllerTest < ActionDispatch::IntegrationTest
  #   setup do
  def setup
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com')
    @user2 = User.create!(name: 'John2', password: 'Sisisi123!', email: 'hola@gmail.com')
    @product = Product.create!(nombre: 'Product Test', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
    @review = Review.create!(tittle: 'Review Title', description: 'Review description', calification: 4,
                             product_id: @product.id, user_id: @user.id)
    sign_in @user
  end

  # Test para insertar una nueva reseña (happy path)
  test 'should insert review' do
    assert_difference('Review.count', 1) do
      post '/review/insertar', params: {
        product_id: @product.id,
        tittle: 'With great power comes great responsibility',
        description: 'I love this product!',
        calification: 5
      }
    end
    assert_redirected_to "/products/leer/#{@product.id}"
    follow_redirect!
    assert_match 'Review creado Correctamente !', flash[:notice]
  end

  test 'should get error if review save fails' do
    Review.any_instance.stubs(:save).returns(false)
    post '/review/insertar', params: {
      product_id: @product.id,
      tittle: 'With great power comes great responsibility',
      description: 'I love this product!',
      calification: 5
    }
    assert_redirected_to "/products/leer/#{@product.id}"
    assert_match 'Hubo un error al guardar la reseña; debe completar todos los campos solicitados.', flash[:error]
  end

  # Test para actualizar una reseña existente (happy path)
  test 'should update review' do
    patch "/review/actualizar/#{@review.id}", params: {
      id: @review.id,
      tittle: 'Updated Title',
      description: 'Updated description',
      calification: 4
    }
    assert_redirected_to "/products/leer/#{@review.product.id}"
    @review.reload
    assert_equal 'Updated Title', @review.tittle
    assert_equal 'Updated description', @review.description
    assert_equal 4, @review.calification.to_i
  end

  # Test para actualizar una reseña existente (camino alternativo: datos incompletos)
  test 'should not update review with incomplete data' do
    patch "/review/actualizar/#{@review.id}", params: {
      id: @review.id,
      tittle: '',
      description: 'Updated description',
      calification: 4
    }
    assert_redirected_to "/products/leer/#{@review.product.id}"
    @review.reload
    assert_not_equal '', @review.tittle
  end

  # Test para eliminar una reseña (happy path para dueño de la reseña)
  test 'user should delete own review' do
    assert_difference('Review.count', -1) do
      delete "/review/eliminar/#{@review.id}"
    end
    assert_redirected_to "/products/leer/#{@review.product.id}"
  end

  test 'should not delete review if wronge id' do
    assert_no_difference('Review.count') do
      assert_raises(ActiveRecord::RecordNotFound) do
        delete '/review/eliminar/9999'
      end
    end
  end
end
