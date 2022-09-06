class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  enum fuel_preference: %i[None Brand SP95 SP98 E10 E85 Gazole GPLc]
  has_many :locations, dependent: :destroy
  belongs_to :brand, optional: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
