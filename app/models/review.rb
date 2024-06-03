class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  # Valida que el campo tittle (título) no esté vacío y tenga una longitud máxima de 100 caracteres.
  validates :tittle, presence: true, length: { maximum: 100 }

  # Valida que el campo description (descripción) no esté vacío y tenga una longitud máxima de 500 caracteres.
  validates :description, presence: true, length: { maximum: 500 }

  # Valida que el campo calification (calificación) no esté vacío y sea un número entero entre 1 y 5.
  validates :calification, presence: true,
                           numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  # Valida que la asociación con el producto (product) esté presente.
end
