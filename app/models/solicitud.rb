class Solicitud < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # Valida que el campo stock no esté vacío y sea un número entero mayor que 0.
  validates :stock, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Valida que el campo status (estado) no esté vacío.
  validates :status, presence: true
end
