# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
User.destroy_all
Product.destroy_all
ShoppingCart.destroy_all

# Create Users
user1 = User.create(email: "user-admin@example.com", password: "password", name: "User admin 1", role: "admin")
user2 = User.create(email: "user-admin2@example.com", password: "password", name: "User admin 2", role: "admin")
user3 = User.create(email: "user3@example.com", password: "password", name: "User 3", role: "user")

# Create Products
product1 = Product.create(user: user1, nombre: "Cancha de badminton", precio: "5000", stock: "5", categories: "Cancha", horarios: "30/06/2024,18:00,19:00;30/06/2024,22:00,23:00;04/07/2024,16:00,17:00")
product2 = Product.create(user: user1, nombre: "Smartwatch", precio: "20000", stock: "20", categories: "Accesorio tecnologico")
product3 = Product.create(user: user2, nombre: "Raqueta de Tenis", precio: "15000", stock: "10", categories: "Accesorio deportivo")
product4 = Product.create(user: user2, nombre: "Mancuernas", precio: "8000", stock: "15", categories: "Accesorio de entrenamiento")

# Create ShoppingCart for User1 with corrected product references
shopping_cart1 = ShoppingCart.create(user: user2, products: { product1.id.to_s => 1, product2.id.to_s => 3 })

# Create another ShoppingCart for User2 with different products
shopping_cart2 = ShoppingCart.create(user: user3, products: { product2.id.to_s => 2, product3.id.to_s => 3, product4.id.to_s => 10})

# User2 makes a solicitud to reserve 1 unit of 'Smartwatch'
solicitud2 = Solicitud.create(user: user2, product: product1, stock: 1, status: "Pendiente", reservation_info: "Solicitud de reserva para el día 30/06/2024, a las 22:00 hrs")

# User3 makes a solicitud to buy 3 units of 'Raqueta de Tenis'
solicitud3 = Solicitud.create(user: user3, product: product3, stock: 3, status: "Aprobada")

puts "Seed data created successfully!"