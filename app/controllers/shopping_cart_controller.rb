class ShoppingCartController < ApplicationController
  # Vista del carro de compras
  def show
    return unless user_signed_in?

    @shopping_cart = ShoppingCart.find_by(user_id: current_user.id)
    return unless @shopping_cart.nil?

    @shopping_cart = crear_carro
  end

  # Vista de detalles del carro de compras
  def details
    if user_signed_in?
      @shopping_cart = ShoppingCart.find_by(user_id: current_user.id)
      @shopping_cart = crear_carro if @shopping_cart.nil?
      # Comprobar si existen elementos en el carro
      if @shopping_cart.products.count.zero?
        flash[:alert] = 'No tienes productos que comprar.'
        redirect_to '/carro'
      else
        # Calcular precio total
        @total_pago = @shopping_cart.precio_total + @shopping_cart.costo_envio
      end
    else
      flash[:alert] = 'Debes iniciar sesión para comprar.'
      redirect_back(fallback_location: root_path)
    end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
  # Agregar producto al carro de compras
  def insertar_producto(buy_now: false)
    if user_signed_in?
      @shopping_cart = ShoppingCart.find_by(user_id: current_user.id)
      # Si no existe carro, crear carro
      @shopping_cart = crear_carro if @shopping_cart.nil?
      # Leer parametros de id producto y cantidad
      product_id = params[:product_id]
      amount = add_product_params[:amount].to_i
      # Comprobar si ya existe la key "product_id" en el carro
      if @shopping_cart.products.key?(product_id)
        # Si existe, sumar cantidad
        @shopping_cart.products[product_id] += amount
      elsif @shopping_cart.products.count < 8
        # Si no existe, crear key con cantidad
        # Además, comprobamos si se superó el limite de productos por compra
        @shopping_cart.products[product_id] = amount
      else
        flash[:alert] =
          'Has alcanzado el máximo de productos en el carro de compras (8). ' \
          'Elimina productos para agregar más o realiza el pago de los productos actuales.'
        redirect_back(fallback_location: root_path)
        return
      end
      # Comprobar si existe stock suficiente y si son maximo 100 unidades
      product = Product.find(product_id)
      if @shopping_cart.products[product_id] > product.stock.to_i
        flash[:alert] =
          "El producto '#{product.nombre}' no tiene suficiente stock para agregarlo al carro de compras."
        redirect_back(fallback_location: root_path)
        return
      end
      if @shopping_cart.products[product_id] > 100
        flash[:alert] =
          "El producto '#{product.nombre}' tiene un máximo de 100 unidades por compra."
        redirect_back(fallback_location: root_path)
        return
      end
      # Guardar carrito
      if @shopping_cart.update(products: @shopping_cart.products)
        if buy_now
          redirect_to '/carro/detalle'
          return
        end
        flash[:notice] = 'Producto agregado al carro de compras'
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = 'Hubo un error al agregar el producto al carro de compras'
        redirect_back(fallback_location: root_path, status: :unprocessable_entity)
      end
    else
      flash[:alert] = 'Debes iniciar sesión para agregar productos al carro de compras.'
      redirect_to '/carro'
    end
  end

  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
  # Eliminar producto del carro de compras
  def eliminar_producto
    @shopping_cart = ShoppingCart.find_by(user_id: current_user.id)
    product = Product.find(params[:product_id])
    if @shopping_cart.products.key?(product.id.to_s)
      @shopping_cart.products.delete(product.id.to_s)
      if @shopping_cart.update(products: @shopping_cart.products)
        flash[:notice] = 'Producto eliminado del carro de compras'
      else
        flash[:alert] = 'Hubo un error al eliminar el producto del carro de compras'
      end
    else
      flash[:alert] = 'El producto no existe en el carro de compras'
    end
    redirect_to '/carro'
  end

  # Comprar ahora
  def comprar_ahora
    insertar_producto(buy_now: true)
  end

  # Realizar compra
  def realizar_compra
    @shopping_cart = ShoppingCart.find_by(user_id: current_user.id)
    if @shopping_cart.nil?
      flash[:alert] = 'No se encontró tu carro de compras. Contacte un administrador.'
      redirect_to '/carro'
    elsif @shopping_cart.products.count.zero?
      flash[:alert] = 'No tienes productos en el carro de compras'
      redirect_to '/carro'
    else
      # Crear solicitud pre-aprobada por cada item en el carro
      # Comprueba primero si todas las solicitudes son válidas
      return redirect_to '/carro' unless comprobar_productos(@shopping_cart)

      # Crear solicitudes y realizar compras
      if crear_solicitudes(@shopping_cart)
        # Limpiar carro de compras
        @shopping_cart.products = {}
        if @shopping_cart.update(products: @shopping_cart.products)
          flash[:notice] = 'Compra realizada exitosamente'
          redirect_to '/solicitud/index'
        else
          flash[:alert] = 'Hubo un error al actualizar el carro. Contacte un administrador.'
          redirect_to '/carro'
        end
      end
    end
  end

  # Limpiar carro de compras
  def limpiar
    @shopping_cart = ShoppingCart.find_by(user_id: current_user.id)
    @shopping_cart.products = {}
    if @shopping_cart.update(products: @shopping_cart.products)
      flash[:notice] = 'Carro de compras limpiado exitosamente'
    else
      flash[:alert] = 'Hubo un error al limpiar el carro de compras. Contacte un administrador.'
    end
    redirect_to '/carro'
  end

  private

  def add_product_params
    params.require(:add).permit(:amount)
  end

  def address_params
    params.require(:address).permit(:nombre, :direccion, :comuna, :region)
  end

  def crear_carro
    shopping_cart = ShoppingCart.new
    shopping_cart.user_id = current_user.id
    # Productos son guardados como {product_id => amount}
    shopping_cart.products = {}
    return shopping_cart if shopping_cart.save


    flash[:alert] = 'Hubo un error al crear el carro. Contacte un administrador.'
    redirect_to :root
  end

  def comprobar_productos(shopping_cart)
    shopping_cart.products.each do |product_id, amount|
      product = Product.find(product_id)
      # Comprobar si hay suficiente stock
      next unless amount > product.stock.to_i

      flash[:alert] =
        "Compra cancelada: El producto '#{product.nombre}' no tiene suficiente stock para realizar la compra. " \
        'Por favor, elimina el producto del carro de compras o reduce la cantidad.'
      return false
    end
    true
  end

  def crear_solicitudes(shopping_cart)
    shopping_cart.products.each do |product_id, amount|
      product = Product.find(product_id)
      solicitud = Solicitud.new
      # Por el momento, las solicitudes de productos son aprobadas
      solicitud.status = 'Aprobada'
      solicitud.stock = amount
      # TODO: Añadir direccion de envio a solicitud
      # address = "#{address_params[:direccion]}, "\
      #  "#{address_params[:comuna]}, #{address_params[:region]}"
      solicitud.product_id = product_id
      solicitud.user_id = current_user.id
      product.stock = product.stock.to_i - amount.to_i
      # Guardar solicitud y actualizar stock
      next if solicitud.save && product.update(stock: product.stock)

      flash[:alert] = 'Hubo un error al realizar la compra. Contacte un administrador.'
      redirect_to '/carro'
      return false
    end
    true
  end
end
