class Product < ApplicationRecord
  belongs_to :user

  # Valida que el campo categories no esté vacío.
  validates :categories, presence: true, inclusion: { in: ['Cancha', 'Accesorio tecnologico',
                                                           'Accesorio deportivo', 'Accesorio de vestir',
                                                           'Accesorio de entrenamiento', 'Suplementos',
                                                           'Equipamiento'] }

  # Valida que el campo nombre no esté vacío.
  validates :nombre, presence: true

  # Valida que el campo stock no esté vacío y sea un número mayor o igual a 0.
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Valida que el campo precio no esté vacío y sea un número mayor o igual a 0.
  validates :precio, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Valida que el campo user_id no esté vacío.

  # Contiene una imagen como attachment.
  has_one_attached :image

  # Establece la relación con el modelo Review y destruye las reviews asociadas cuando se elimina el producto.
  has_many :reviews, dependent: :destroy

  # Establece la relación con el modelo Message y destruye los mensajes asociados cuando se elimina el producto.
  has_many :messages, dependent: :destroy

  # Establece la relación con el modelo Solicitud y destruye las solicitudes asociadas cuando se elimina el producto.
  has_many :solicituds, dependent: :destroy
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :precio, numericality: { greater_than_or_equal_to: 0 }
end
