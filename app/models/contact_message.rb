class ContactMessage < ApplicationRecord
  # Valida los campos title, body, name y mail
  # Los campos no pueden estar vacíos y deben tener una longitud adecuada
  # El correo debe ser válido.
  # Si se ingresa el campo phone, debe ser un teléfono tipo (+56X XXXX XXXX).

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 500 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :mail, presence: true, length: { maximum: 50 }, format: {
    with: URI::MailTo::EMAIL_REGEXP
  }
  validates :phone, length: { maximum: 20 }, format: {
    with: /\A\+56\d{9}\z/,
    message: 'El formato del teléfono debe ser +56XXXXXXXXX'
  }, allow_blank: true
end
