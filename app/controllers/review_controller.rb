# Controlador para las acciones relacionadas con las reseñas de productos
class ReviewController < ApplicationController
  load_and_authorize_resource

  # Acción para crear una nueva reseña
  def insertar
    @product = Product.find(params[:product_id])
    @review = Review.new(parametros)
    @review.product = @product
    @review.user_id = current_user.id

    if @review.save
      flash[:notice] = 'Review creado Correctamente !'
    else
      flash[:error] =
        'Hubo un error al guardar la reseña; debe completar todos los campos solicitados.'
    end
    redirect_to "/products/leer/#{params[:product_id]}"
  end

  # Acción para actualizar una reseña existente
  def actualizar_review
    @reviews = Review.find(params[:id])

    unless @reviews.update(parametros)
      flash[:error] = 'Hubo un error al editar la reseña. Complete todos los campos solicitados!'
    end
    redirect_to "/products/leer/#{@reviews.product.id}"
  end

  # Acción para eliminar una reseña existente
  def eliminar
    @reviews = Review.find(params[:id])
    @reviews.destroy
    redirect_to "/products/leer/#{@reviews.product.id}"
  end

  private

  # Método para filtrar y permitir los parámetros requeridos
  def parametros
    params.permit(:tittle, :description, :calification)
  end
end
