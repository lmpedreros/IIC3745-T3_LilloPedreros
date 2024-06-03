# Controlador para gestionar las solicitudes de compra
class SolicitudController < ApplicationController
  # Muestra las solicitudes y productos asociados del usuario actual
  def index
    @solicitudes = Solicitud.where(user_id: current_user.id)
    @productos = Product.where(user_id: current_user.id)
  end

  # rubocop:disable Metrics/AbcSize
  # Crea una nueva solicitud de compra
  def insertar
    @solicitud = Solicitud.new
    @solicitud.status = 'Pendiente'
    @solicitud.stock = parametros[:stock]
    producto = Product.find(params[:product_id])
    @solicitud.product_id = producto.id
    @solicitud.user_id = current_user.id

    if @solicitud.stock.to_i > producto.stock.to_i
      flash[:error] = 'No hay suficiente stock para realizar la solicitud!'
      redirect_to "/products/leer/#{params[:product_id]}"
      return
    else
      producto.stock = producto.stock.to_i - @solicitud.stock.to_i
    end

    if params[:solicitud][:reservation_datetime].present?
      fecha = params[:solicitud][:reservation_datetime].to_datetime
      dia = fecha.strftime('%d/%m/%Y')
      hora = fecha.strftime('%H:%M')
      @solicitud.reservation_info = "Solicitud de reserva para el día #{dia}, a las #{hora} hrs"
    end

    if @solicitud.save && producto.update(stock: producto.stock)
      flash[:notice] = 'Solicitud de compra creada correctamente!'
      redirect_to "/products/leer/#{params[:product_id]}"
    else
      flash[:error] = 'Hubo un error al guardar la solicitud!'
      redirect_to "/products/leer/#{params[:product_id]}"
      Rails.logger.debug @solicitud.errors.full_messages
    end
  end

  # rubocop:enable Metrics/AbcSize
  # Elimina una solicitud de compra
  def eliminar
    @solicitud = Solicitud.find(params[:id])
    producto = Product.find(@solicitud.product_id)
    producto.stock = producto.stock.to_i + @solicitud.stock.to_i

    if @solicitud.destroy && producto.update(stock: producto.stock)
      flash[:notice] = 'Solicitud eliminada correctamente!'
    else
      flash[:error] = 'Hubo un error al eliminar la solicitud!'
    end
    redirect_to '/solicitud/index'
  end

  # Actualiza el estado de una solicitud a "Aprobada"
  def actualizar
    @solicitud = Solicitud.find(params[:id])
    @solicitud.status = 'Aprobada'

    if @solicitud.update(status: @solicitud.status)
      flash[:notice] = 'Solicitud aprobada correctamente!'
    else
      flash[:error] = 'Hubo un error al aprobar la solicitud!'
    end
    redirect_to '/solicitud/index'
  end

  private

  # Permite los parámetros necesarios para la creación de una solicitud
  def parametros
    params.require(:solicitud).permit(:stock,
                                      :reservation_datetime).merge(product_id: params[:product_id])
  end
end
