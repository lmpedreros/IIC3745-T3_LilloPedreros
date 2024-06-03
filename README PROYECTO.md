## Descripción del sistema
El sistema cuenta con dos tipos de usuarios: usuario normal y usuario administrador. El usuario administrador tiene acceso a todas las funcionalidades del sitio, como eliminar reseñas, productos y mensajes. Por otro lado, el usuario normal tiene ciertas restricciones, como no poder eliminar ni crear productos, pero sí puede crear reseñas, realizar compras y enviar mensajes.

Los mensajes se implementan siguiendo el estilo de un chat similar al de Mercado Libre. Se muestran al final de la página de detalles de un producto específico y también se puede acceder a ellos desde el menú de perfil del usuario.

Las solicitudes de compra están diseñadas para que un usuario comprador envíe una solicitud a un usuario vendedor. El vendedor puede aceptar o rechazar la solicitud. Se asume que una vez que un usuario compra un producto, el sistema aprueba automáticamente los métodos de pago y se realiza la compra directamente. Si un producto recibe una solicitud y tiene un determinado stock disponible, se resta ese stock hasta que se apruebe o rechace la solicitud. En caso de que la solicitud sea rechazada, se devuelve el stock al producto. Si un producto se queda sin stock, no se mostrará como disponible en la tienda.

En cuanto al filtro por categoría, se asume que cada producto tiene una única categoría principal que se diferencia claramente de las demás. Desde la vista de productos, se pueden aplicar filtros por categoría. Al crear un producto, siempre se asigna una categoría.

También se asume que mientras un vendedor no aprueba o rechaza una solicitud de compra, el usuario comprador puede retirar y cancelar la solicitud. No se especifica la implementación de métodos de pago y transacciones monetarias, ya que se considera que se verifican externamente al sistema.

Todas las vistas están diseñadas utilizando el framework Bulma y se han personalizado según las preferencias del equipo de desarrollo.

En la lista de deseos, los usuarios pueden guardar productos para acceder a ellos más tarde. Si un producto ya está en la lista de deseos, no se agregará nuevamente. Desde la vista de deseos, los usuarios pueden eliminar productos de su lista.

Respecto al buscador de productos por nombre, el codigo está hecho para ser de facil ajuste, pero de momento se asume que solo se puede aplicar un filtro a la vez, por categoria o por nombre, al filtrar por categoria se asume que se quiere ver todos los productos de la pagina que tienen esa categoria, y en el caso del filtro por nombre lo mismo. En el caso de querer habilitar la opción de aceptar ambos filtros combinados es solo cosa de agregarlo para el siguiente sprint como tarea pequeña.

Otra consideracion respecto a la conformacion de los usuarios, estos estan programados para tener un registro de solicitudes de compra y poder ser habilitados para crear y vender productos, esto se eliminó de la vista para asumir que solo los usuarios admin pueden hacer esto, pero si se desea a futuro modificarlo para que un usuario pueda tener una cuenta como vendedor u ofrecedor de servicios esto ya está programado de esta forma.

Respecto a la manera de comprar productos o agendar una cancha, las canchas pueden ser reservadas por horario, una vez se hace la reserva esta debe ser aprobada por el propietario de la cancha, en cambio para los productos estos son automaticamente aceptados por el sistema (lo que se haria por el servicio de pago si fuese implementado). 

Todo producto se puede agregar previamente a un carrito de compras el cual puede ser accedido por el usuario, nuevamente, al hacer la compra el sistema automaticamente acepta la solicitud. Para el caso de las canchas se decido no incluirlas en el carrito de compras ya que corresponden a reservas y no compra de productos.

La lista de cosas que un usuario tiene en posicion se asume parte de la vista de solicitudes del propio usuario, en esta se ven las solicitudes pendientes y solicitudes aceptadas que equivalen a los productos que se obtienen y las canchas reservadas.

Para crear una cuenta de rol admin, esta se planea tener creada desde antes, pero ya que se necesita revisar, se ha agregado un campo para registrar una cuenta de tipo admin de manera sencilla, esto planea eliminar a futuro, pero de momento basta con ingresar la palabra admin, en caso de que se quisiese dejar como password de admin o algo por el estilo, simplementa basta con ocultar las instrucciones y crear una, pero se asume lo anterior por el momento. Tambien este campo sirve para agregar otros tipos de roles, por el momento se dejara asi en caso de querer escalar la pagina y permitir crear usuarios vendedores o con tipos distintos a un usuario normal y admin.

Para hacer la pagina mas dinamica y representar un estado mas alegre frente a otras tiendas online comunes se decide usar la api de JokeAPI para agregar chistes al comienzo de los detalles de cada producto, estos son aleatorios y tienen la intencion de dejar un poco la monotonia de la pagina divirtiendo a los usuarios.