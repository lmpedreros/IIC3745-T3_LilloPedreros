class MessageController < ApplicationController
  load_and_authorize_resource

  # Inserta un nuevo mensaje en un producto.
  #
  # Crea una instancia de Message utilizando los parámetros permitidos.
  # Asigna el ID del producto y el ID del usuario actual al mensaje.
  # Si se proporciona un parámetro de ancestro, establece el mensaje padre correspondiente.
  # Si el mensaje se guarda correctamente, se muestra un mensaje de éxito y redirige a la página del producto.
  # En caso de error al guardar, se muestra un mensaje de error y se redirige a la página de lectura del producto.
  #
  # @return [void]
  #
  # @example
  #   POST /messages/insertar
  #   def insertar
  #     # Código del método
  #   end
  #
  def insertar
    @product = Product.find(params[:product_id])
    @messages = @product.messages
    @message = Message.new(parametros)
    @message.product_id = @product.id
    @message.user_id = current_user.id
    @message.parent = Message.find(params[:ancestry]) if params[:ancestry].present?

    if @message.save
      flash[:notice] = 'Pregunta creada correctamente!'
    else
      flash[:error] =
        'Hubo un error al guardar la pregunta. ¡Completa todos los campos solicitados!'
    end
    redirect_to "/products/leer/#{params[:product_id]}"
  end

  # Elimina un mensaje.
  #
  # Encuentra el mensaje por su ID y lo elimina.
  # Luego, redirige a la página de lectura del producto al que pertenecía el mensaje.
  #
  # @return [void]
  #
  # @example
  #   DELETE /messages/eliminar
  #   def eliminar
  #     # Código del método
  #   end
  #
  def eliminar
    @message = Message.find(params[:message_id])
    @message.destroy
    redirect_to "/products/leer/#{params[:product_id]}"
  end

  private

  # Parámetros permitidos para el modelo Message.
  #
  # Define los parámetros permitidos para el modelo Message.
  # Solo se permite el campo body y ancestry, y se fusiona con el product_id proporcionado.
  #
  # @return [ActionController::Parameters] Los parámetros permitidos.
  #
  def parametros
    params.require(:message).permit(:body, :ancestry).merge(product_id: params[:product_id])
  end
end
