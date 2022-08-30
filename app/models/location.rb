class Location < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :address, presence: true
end
