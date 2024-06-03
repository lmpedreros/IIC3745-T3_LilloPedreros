class Message < ApplicationRecord
  has_ancestry
  belongs_to :user
  belongs_to :product

  # Valida que el campo body no esté vacío.
  validates :body, presence: true

  # Valida que el campo user_id no esté vacío.

  # Valida que el campo product_id no esté vacío.
end
