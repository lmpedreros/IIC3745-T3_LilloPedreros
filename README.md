## Tarea 4

### Logros de la entrega:

**Mejorar el sistema de reservas:**
* Se realizó un cambio en el archivo app/views/products/leer.html.erb. Este cambio consiste en que la eleccion de fecha y hora de la reserva ahora es un dropdown con las opciones colocadas por el creador de la reserva, de este modo ahora solo se puede seleccionar las fechas y horas correctas.
* Al ser un cambio visual y no de modelo, no se tuvieron que hacer cambios a los test de la tarea anterior.

**Tests de Sistema(cypress/e2e)**
* Lucas Martín Pedreros Soto:
   + *product_navigation*\
   Test comienza en la LandingPage, se traslada a iniciar sesión, se inicia sesion, y luego desde la LandingPage se va a "Ver canchas y productos".
   + *solicitud_navigation*\
   Test comienza en la LandingPage, se traslada a iniciar sesión, se inicia sesion, y luego desde la LandingPage se va a "Solicitudes de compra y reservas".
* Ignacio Andrés Lillo Molina:
   + *shopping_cart_test*\
   Test comienza en la LandingPage, se traslada a iniciar sesión, se inicia sesion, y luego desde la LandingPage se presiona "Mi carrito" para ver el carrito de compra.
   + *view_account_test*\
   Test comienza en la LandingPage, se traslada a iniciar sesión, se inicia sesion, y luego desde la LandingPage se presiona "Mi cuenta" para ver el perfil del usuario.

**Test de Sistema probando formulario**
* Lucas Martín Pedreros Soto:
   + *message_creation*
* Ignacio Andrés Lillo Molina:
   + *product_creation*


### Informacion para el correcto:
Incluir aqui cualquier detalle que pueda ser importante al momento de corregir.

* Test A_register_test.cy.js es utilizado solo para crear un usuario para ser utilizado en los demás test, por lo que corre correctamente la primera vez, sin embargo las siguientes veces aparece como failed ya que el usuario ya está creado. Este test no debería contar para la evaluación.

* Informacion de T3 que también está en T4
    + [shopping_cart_controller.rb] Se agrego una linea a shopping_cart_controller.rb. En la funcion insertar_producto se coloco al comienzo "buy_now = params[:buy_now] || false" para que buy_now pueda ser true y poder testear la linea de if buy_now. Sin ese agregado buy_now es siempre false.
    + [shopping_cart_controller.rb] No se pudo testear la funcion "address_params" de shopping_cart_controller, ya que es una funcion privada y no es utilizada en ninguna parte del codigo. Por lo que es imposible obtener esas lineas para el coverage.
    + [shopping_cart_controller.rb] En shopping_cart_controller, modifique ligeramente insert_product para que cuando se utiliza la funcion crea_carro y este devuelve un string, insert_product muestra el error y termina. Antes de hacer los cambios, cuando crear_carro mostraba un error porque shopping_cart.save era igual a flaso, insert_product seguia funcionando con shopping_cart como un string lo que siempre tiraba error. Por lo que realizamos esos cambios para poder testear correctamente crear_carro cuando shopping_cart.save era igual a falso.

\
**Consideración:**
* Tal y como se indica en el enunciado de la tarea, se arreglaron los tests que faltaban en la tarea anterior.

* Correr los tests con 'yarn cypress run'