class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:facebook, :twitter]

  validates :username, presence: true, uniqueness: true, 
            length: {in: 5..20, too_short: "Debe tener al menos 5 caracteres", too_long: "Debe tener máximo 20 caracteres"},
            format: {with: /([A-Za-z0-9\-\_]+)/, message: "puede sólo contener letras, números y guiones"}

  #validate :validacion_personalizada, on: :create


  def self.find_or_create_by_omniauth(auth)
    user = User.where(provider: auth[:provider], uid: auth[:uid]).first
  	unless user
  		user = User.create(
  			name: auth[:name],
  			email: auth[:email],
  			uid: auth[:uid],
  			provider: auth[:provider],
  			password: Devise.friendly_token[0..20]
  		)
  	end
  end

=begin
  private
  def validacion_personalizada
    if true
      
    else
      errors.add(:username,"Tu username no es válido")
    end
  end
=end
end
