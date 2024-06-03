class ProductsController < ApplicationController
  load_and_authorize_resource

  @root_url = '/products/index'

  layout 'application'

  add_flash_types :notice

  # Listar todos los productos de la Base de Datos
  def index
    @products = Product.all

    if params[:category].present? && params[:search].present?
      @products = @products.where(categories: params[:category]).where('nombre LIKE ?',
                                                                       "%#{params[:search]}%")
    elsif params[:category].present?
      @products = @products.where(categories: params[:category])
    elsif params[:search].present?
      @products = @products.where('nombre LIKE ?', "%#{params[:search]}%")
    end
  end

  # Leer los detalles de un producto
  def leer
    @joke = JokeApiService.fetch_joke('Misc', 'single')
    @product = Product.find(params[:id])
    @messages = @product.messages
    @reviews = @product.reviews
    @shown_message_ids = []

    total_califications = 0
    @reviews.each do |review|
      calification = review.calification.to_i
      total_califications += calification
    end
    if @product.horarios.nil?
      @horarios = nil
    else
      dias = @product.horarios.split(';')
      horarios = []
      dias.each do |dia|
        horarios << dia.split(',')
      end
      @horarios = horarios
    end
    @calification_mean = if @reviews.empty?
                           nil
                         else
                           (total_califications.to_f / @reviews.length).round(1)
                         end
  end

  # Llamamos a la vista con el formulario para crear un producto
  def crear
    @product = Product.new
  end

  # Insertar un producto a la lista de deseados
  def insert_deseado
    # Desactiva temporalmente las validaciones de contraseña

    if current_user.deseados.nil?
      current_user.deseados = [params[:product_id].to_s]
    else
      current_user.deseados << params[:product_id].to_s
    end
    if current_user.save
      flash[:notice] = 'Producto agregado a la lista de deseados'
    else
      flash[:error] =
        "Hubo un error al guardar los cambios: #{current_user.errors.full_messages.join(', ')}"
    end
    redirect_to "/products/leer/#{params[:product_id]}"
  end

  # Procesamos la creación de un producto en la base de datos
  def insertar
    if current_user.role == 'admin'
      @product = Product.new(parametros)
      @product.user_id = current_user.id
      # Insertamos un producto en la base de datos
      if @product.save
        flash[:notice] = 'Producto creado Correctamente !'
        redirect_to '/products/index'
      else
        flash[:error] =
          "Hubo un error al guardar el producto: #{@product.errors.full_messages.join(', ')}"
        redirect_to '/products/crear'
      end
    else
      flash[:alert] = 'Debes ser un administrador para crear un producto.'
      redirect_to '/products/index'
    end
  end

  def actualizar
    @product = Product.find(params[:id])
  end

  # Procesamos la actualización de un producto en la base de datos
  def actualizar_producto
    if current_user.role == 'admin'
      @product = Product.find(params[:id])
      if @product.update(parametros)
        redirect_to '/products/index'
      else
        flash[:error] =
          'Hubo un error al guardar el producto. Complete todos los campos solicitados!'
        redirect_to "/products/actualizar/#{params[:id]}"
      end
    else
      flash[:alert] = 'Debes ser un administrador para modificar un producto.'
      redirect_to '/products/index'
    end
  end

  # Procesamos la eliminación de un producto de la base de datos
  def eliminar
    if current_user.role == 'admin'
      # Eliminamos un determinado producto en la base de datos, pasamos el 'id' del producto a eliminar
      @products = Product.find(params[:id])
      @products.destroy
    else
      flash[:alert] = 'Debes ser un administrador para eliminar un producto.'
    end
    redirect_to '/products/index'
  end

  # Parámetros o campos que insertamos o actualizamos en la base de datos
  private

  def parametros
    params.require(:product).permit(:nombre, :precio, :stock, :image, :categories, :horarios)
  end
end
