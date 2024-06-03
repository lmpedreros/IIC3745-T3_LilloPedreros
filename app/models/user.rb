class User < ApplicationRecord
  # Incluye los módulos de autenticación de Devise.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Valida que el campo name esté presente y tenga una longitud mínima de 2 caracteres y máxima de 25 caracteres.
  validates :name, presence: true, length: { minimum: 2, maximum: 25 }

  # Valida que el campo email esté presente y sea único en la base de datos.
  validates :email, presence: true, uniqueness: true

  # Establece la relación con el modelo Product y destruye los productos asociados cuando se elimina el usuario.
  has_many :products, dependent: :destroy

  # Establece la relación con el modelo Review y destruye las reviews asociadas cuando se elimina el usuario.
  has_many :reviews, dependent: :destroy

  # Establece la relación con el modelo Message y destruye los mensajes asociados cuando se elimina el usuario.
  has_many :messages, dependent: :destroy

  # Establece la relación con el modelo Solicitud y destruye las solicitudes asociadas cuando se elimina el usuario.
  has_many :solicituds, dependent: :destroy
  has_one :shopping_cart, dependent: :destroy

  # Define un atributo llamado "deseados" como un texto con un valor predeterminado vacío y un array.
  attribute :deseados, :text, default: -> { [] }, array: true
  validate :validate_new_wish_product

  # Contiene una imagen como attachment.
  has_one_attached :image

  # Verifica si el usuario tiene el rol de administrador.
  def admin?
    role == 'admin'
  end

  # Anula la validación de contraseña de Devise.
  # Se llama por el lado de devise al instanciar/modificar no es necesario testear por separado
  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

  # Valida la fortaleza de la contraseña.
  # Se llama por el lado de devise al instanciar/modificar no es necesario testear por separado
  def validate_password_strength
    return if password.blank?

    return if password.match(/(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x)

    errors.add(:password, 'no es válido incluir como minimo una mayuscula, minuscula y un simbolo')
  end

  # Valida que el producto que se esta agregando la lista de deseados exista. Es una validacion
  def validate_new_wish_product
    return if deseados.empty? || Product.exists?(deseados[-1])

    errors.add(:deseados, 'el articulo que se quiere ingresar a la lista de deseados no es valido')
  end
end
