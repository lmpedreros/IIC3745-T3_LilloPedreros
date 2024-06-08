## Tarea 3

### Logros de la entrega:
[Recuerden especificar quien hizo cada cosa]

**Modelos:**
* Lucas Martín Pedreros Soto:
   + *Shopping_cart_test*
   + *Contact_message_test*
   + *Solicitud_test*
* Ignacio Andrés Lillo Molina:
   + *User_test*
   + *Product_test*
   + *Message_test*
   + *Review_test*

**Controladores:**
* Lucas Martín Pedreros Soto:
   + *Shopping_cart_controller_test*
   + *Contact_message_controller_test*
   + *Solicitud_controller_test*
   + *Pages_controller_test*
* Ignacio Andrés Lillo Molina:
   + *User_controller_test*
   + *Product_controller_test*
   + *Message_controller_test*
   + *Review_controller_test*

### Informacion para el correcto:
Incluir aqui cualquier detalle que pueda ser importante al momento de corregir.

* [shopping_cart_controller.rb] Se agrego una linea a shopping_cart_controller.rb. En la funcion insertar_producto se coloco al comienzo "buy_now = params[:buy_now] || false" para que buy_now pueda ser true y poder testear la linea de if buy_now. Sin ese agregado buy_now es siempre false.
* [shopping_cart_controller.rb] No se pudo testear la funcion "address_params" de shopping_cart_controller, ya que es una funcion privada y no es utilizada en ninguna parte del codigo. Por lo que es imposible obtener esas lineas para el coverage.
* [shopping_cart_controller.rb] En shopping_cart_controller, modifique ligeramente insert_product para que cuando se utiliza la funcion crea_carro y este devuelve un string, insert_product muestra el error y termina. Antes de hacer los cambios, cuando crear_carro mostraba un error porque shopping_cart.save era igual a flaso, insert_product seguia funcionando con shopping_cart como un string lo que siempre tiraba error. Por lo que realizamos esos cambios para poder testear correctamente crear_carro cuando shopping_cart.save era igual a falso.


**Consideración:** Para esta entrega usamos el cupón para entregar dos días más tarde.