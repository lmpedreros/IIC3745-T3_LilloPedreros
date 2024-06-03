class ShoppingCart < ApplicationRecord
  belongs_to :user
  # Validaciones
  validates :products, presence: true, allow_blank: true

  # Funciones
  def precio_total
    total = 0
    products.each do |product_id, amount|
      product = Product.find_by(id: product_id)
      total += product.precio.to_i * amount unless product.nil?
    end
    total
  end

  def costo_envio
    # Se asume una tarifa fija de envío por producto de $1000
    total = 1000
    # Por cada producto, se añade un 5% del precio del producto
    products.each do |product_id, amount|
      product = Product.find_by(id: product_id)
      total += (product.precio.to_i * amount * 0.05).round(0) unless product.nil?
    end
    total
  end
end
