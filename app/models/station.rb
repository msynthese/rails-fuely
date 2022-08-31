class Station < ApplicationRecord
  belongs_to :brand

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
