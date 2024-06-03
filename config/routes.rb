Rails.application.routes.draw do
  # Rutas generales
  root 'pages#index'
  get 'pages/index'
  get '/', to: 'pages#index'
  get '/contacto', to: 'contact_message#mostrar'
  get '/accesorios', to: 'pages#accessorios'
  get '/reserva', to: 'pages#reserva'

  # Rutas de products
  get 'products/index', to: 'products#index' # Ruta de la vista principal de los registros
  get 'products/leer/:id', to: 'products#leer' # Ruta de la vista leer o ver los detalles de un registro
  get 'products/crear', to: 'products#crear' # Ruta de la vista para crear un registro
  post 'products/insertar', to: 'products#insertar' # Ruta que procesa la creación de un registro en la base de datos
  get 'products/actualizar/:id', to: 'products#actualizar' # Ruta de la vista para actualizar un registro
  patch 'products/actualizar/:id', to: 'products#actualizar_producto' # Ruta de la vista para actualizar un registro
  post 'products/editar/:id', to: 'products#editar' # Ruta que procesa la actualización de un registro en la database
  delete 'products/eliminar/:id', to: 'products#eliminar' # Ruta para eliminar un registro de la base de datos
  post 'products/insert_deseado/:product_id', to: 'products#insert_deseado' # Guardar producto en la lista de deseados

  # Rutas de usuario y devise
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' },
                     path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  get '/users/show', to: 'users#show', as: 'user_show'
  get '/users/deseados', to: 'users#deseados', as: 'user_deseados'
  get '/users/mensajes', to: 'users#mensajes', as: 'user_mensajes'
  # Ruta para eliminar un deseado
  delete '/users/eliminar_deseado/:deseado_id', to: 'users#eliminar_deseado',
                                                as: 'user_eliminar_deseado'
  # Ruta para actualizar una imagen
  patch '/users/actualizar_imagen', to: 'users#actualizar_imagen', as: 'user_actualizar_imagen'

  # Rutas de reviews
  post 'review/insertar', to: 'review#insertar' # Ruta que procesa la creación de un review en la base de datos
  patch 'review/actualizar/:id', to: 'review#actualizar_review' # Ruta patch para actualizar un review
  delete 'review/eliminar/:id', to: 'review#eliminar' # Ruta para eliminar un review de la base de datos

  # Rutas de messages

  get 'message/leer/:id', to: 'message#leer' # Ruta de la vista leer o ver los detalles de un mensaje
  post 'message/insertar', to: 'message#insertar' # Ruta que procesa la creación de un mensaje en la base de datos
  delete '/message/eliminar', to: 'message#eliminar' # Ruta para eliminar un mensaje de la base de datos

  # Rutas de solicitud
  post 'solicitud/insertar', to: 'solicitud#insertar' # Procesa la creación de una solicitud en la base de datos
  get 'solicitud/index', to: 'solicitud#index' # Ruta de la vista principal de las solicitudes
  get 'solicitud/leer/:id', to: 'solicitud#leer' # Ruta de la vista leer o ver los detalles de una solicitud
  delete 'solicitud/eliminar/:id', to: 'solicitud#eliminar' # Ruta para eliminar una solicitud de la base de datos
  patch 'solicitud/actualizar/:id', to: 'solicitud#actualizar' # Ruta de la vista para actualizar una solicitud

  # Rutas de contacto
  post 'contacto/crear', to: 'contact_message#crear' # Ruta que procesa la creación de un mensaje de contacto
  delete 'contacto/eliminar/:id', to: 'contact_message#eliminar' # Ruta para eliminar un mensaje de contacto}
  delete 'contacto/limpiar', to: 'contact_message#limpiar' # Ruta para eliminar todos los mensajes de contacto

  # Rutas del carro de compras
  get 'carro', to: 'shopping_cart#show' # Ruta de la vista principal del carro de compras
  get 'carro/detalle', to: 'shopping_cart#details' # Ruta de la vista para pagar los productos del carro
  post 'carro/insertar_producto', to: 'shopping_cart#insertar_producto' # Ruta para añadir producto en el carro
  post 'carro/comprar_ahora', to: 'shopping_cart#comprar_ahora' # Ruta para comprar un producto
  delete 'carro/eliminar_producto/:product_id', to: 'shopping_cart#eliminar_producto' # Eliminar un producto del carro
  delete 'carro/limpiar', to: 'shopping_cart#limpiar' # Ruta para eliminar todos los productos del carro de compras
  post 'carro/realizar_compra', to: 'shopping_cart#realizar_compra' # Ruta para comprar de los productos del carro
end
