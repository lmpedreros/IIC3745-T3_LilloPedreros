# Proyecto DCCinema Setup

## Requisitos
* ruby 3.1.3
* rails 7 (la version correcta se deberia instalar solo con el bundler)
* PostgreSQL
* yarn (No es necesario al inicio. Solamente lo van a necesitar si en la tarea 4 trabajan con cypress)

## Instalación

Primero tienes que definir las variables de entorno DB_USER y DB_PASSWORD  en tu computador las cuales seran usadas para la base de datos de PostgreSQL

Luego ejecutar lo siguiente:

```
bundle install
```

```
rails db:create
```

```
rails db:migrate
```


## Correr la pagina

Para levantar el servidor correr el siguiente comando, se debería levantar en el localhost puerto ```3000```

```
rails server
```

Usuarios de un sistema operativo distinto a windows pueden necesitar descomentar la linea:

workers ENV.fetch("WEB_CONCURRENCY") { 4 }

En el archivo config/puma.rb
## Correr tests
Antes de ejecutar los tests correr
```
rails db:migrate RAILS_ENV=test
```

Para ejecutar los tests unitarios y de integracion de MiniTest se puede usar:

```
rails test
```

Lo anterior no incluye los tests de sistema

Para ejecutar los tests de Rspec se puede utilizar
```
rspec
```
## Usuario Administrador
Para crear un usuario administrador es necesario crear un usuario con el rol admin.
Esto tambien es posible en el formulario de registro introduciendo admin como la palabra secreta consideren esto como algo temporal de la pagina para su comodidad.