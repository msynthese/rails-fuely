class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  enum fuel_preference: %i[SP95 SP98 E10 E85 Gazole GPLc Brand]
  enum brand_preference: ["All" "Agip" "Auchan" "Avia" "BP" "Casino" "Elan" "Esso Express" "Esso" "Intermarché" "Intermarché Contact" "Shell" "SystèmeU" "Total" "Géant" "Carrefour Express" "Carrefour" "Carrefour Market" "Leclerc" "Indépendant sans enseigne"]
  has_many :locations, dependent: :destroy
  belongs_to :brand, optional: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :fuel_preference, presence: true, on: :update
end
