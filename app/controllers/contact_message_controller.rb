class ContactMessageController < ApplicationController
  # Crea un nuevo mensaje de contacto.
  #
  # Crea una instancia de ContactMessage utilizando los parámetros permitidos.
  # Si el mensaje se guarda correctamente, se muestra un mensaje de éxito y se redirige a la página de contacto.
  # En caso de error al guardar, muestra un mensaje de error y redirige a la página de contacto
  # con el estado "unprocessable_entity".
  #
  # @return [void]
  #
  # @example
  #   POST /contact_messages
  #   def crear
  #     # Código del método
  #   end
  #
  def crear
    @contact_message = ContactMessage.new(contact_message_params)
    if @contact_message.save
      flash[:notice] = 'Mensaje de contacto enviado correctamente'
    else
      flash[:alert] =
        "Error al enviar el mensaje de contacto: #{@contact_message.errors.full_messages.join(', ')}"
    end
    redirect_to '/contacto'
  end

  # Muestra todos los mensajes de contacto en orden de creación.
  #
  # Recupera todos los mensajes de contacto y los ordena por fecha de creación descendente.
  # Luego, renderiza la vista "contacto".
  #
  # @return [void]
  #
  # @example
  #   GET /contact_messages
  #   def mostrar
  #     # Código del método
  #   end
  #
  def mostrar
    @contact_messages = ContactMessage.all.order(created_at: :desc)
    render 'contacto'
  end

  # Elimina un mensaje de contacto.
  #
  # Solo los administradores pueden eliminar mensajes de contacto.
  # Encuentra el mensaje de contacto por su ID y lo elimina.
  # Si se elimina correctamente, se muestra un mensaje de éxito y se redirige a la página de contacto.
  # En caso de error al eliminar, se muestra un mensaje de error y se redirige a la página de contacto.
  #
  # @return [void]
  #
  # @example
  #   DELETE /contact_messages/1
  #   def eliminar
  #     # Código del método
  #   end
  #
  def eliminar
    if current_user.role == 'admin'
      @contact_message = ContactMessage.find_by(id: params[:id])
      if !@contact_message.nil? && @contact_message.destroy
        flash[:notice] = 'Mensaje de contacto eliminado correctamente'
      else
        flash[:alert] = 'Error al eliminar el mensaje de contacto'
      end
    else
      flash[:alert] = 'Debes ser un administrador para eliminar un mensaje de contacto.'
    end
    redirect_to '/contacto'
  end

  # Elimina todos los mensajes de contacto.
  #
  # Solo los administradores pueden eliminar todos los mensajes de contacto.
  # Encuentra todos los mensajes de contacto y los elimina.
  # Si se eliminan correctamente, se muestra un mensaje de éxito y se redirige a la página de contacto.
  # En caso de error al eliminar, se muestra un mensaje de error y se redirige a la página de contacto.
  #
  # @return [void]
  #
  # @example
  #   DELETE /contact_messages/limpiar
  #   def limpiar
  #     # Código del método
  #   end
  #
  def limpiar
    if current_user.role == 'admin'
      @contact_messages = ContactMessage.all
      if !@contact_messages.empty? && @contact_messages.destroy_all
        flash[:notice] = 'Mensajes de contacto eliminados correctamente'
      else
        flash[:alert] = 'Error al eliminar los mensajes de contacto'
      end
    else
      flash[:alert] = 'Debes ser un administrador para eliminar los mensajes de contacto.'
    end
    redirect_to '/contacto'
  end

  private

  # Parámetros permitidos para el modelo ContactMessage.
  #
  # Define los parámetros permitidos para el modelo ContactMessage.
  # Solo se permiten los campos: name, mail, phone, title, body.
  #
  # @return [ActionController::Parameters] Los parámetros permitidos.
  #
  def contact_message_params
    params.require(:contact).permit(:name, :mail, :phone, :title, :body)
  end
end
