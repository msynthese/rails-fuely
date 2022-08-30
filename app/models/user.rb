class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum fuel_preference: %i[None SP95 SP98 E10 E85 Gazole GPLc]
  # enum brand_preference: %i[None Agip Avia BP Elan Esso Total shell]
end
