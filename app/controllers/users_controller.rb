# Controlador para gestionar los usuarios
class UsersController < ApplicationController
  # Muestra los detalles del usuario actual
  def show
    @user = current_user
  end

  # Muestra los productos deseados por el usuario actual
  def deseados
    @deseados = current_user.deseados
  end

  # Muestra los mensajes del usuario actual
  def mensajes
    @user_messages = Message.where(user_id: current_user.id)
    @shown_message_ids = []
  end

  # Actualiza la imagen del usuario
  def actualizar_imagen
    if params[:image].present? && params[:image].content_type.in?(%w[image/jpeg image/png image/gif image/webp
                                                                     image/jpg])
      current_user.image = params[:image]
      current_user.save(validate: false)
      flash[:notice] = 'Imagen actualizada correctamente'
    else
      flash[:error] =
        'Hubo un error al actualizar la imagen. Verifique que la imagen es de formato jpg, jpeg, png, gif o webp'
    end
    redirect_to '/users/show'
  end

  # Elimina un producto de la lista de deseados del usuario
  def eliminar_deseado
    deseado = params[:deseado_id]
    current_user.deseados.delete(deseado)

    if current_user.save(validate: false)
      flash[:notice] = 'Producto quitado de la lista de deseados'
    else
      flash[:error] = 'Hubo un error al quitar el producto de la lista de deseados'
    end
    redirect_to '/users/deseados'
  end
end
