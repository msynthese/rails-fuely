class Brand < ApplicationRecord
  has_many :users, dependent: :nullify
  # A user is not obliged to set its preferred brand. Hence when a brand is destroyed it should not destroy its related users but just nullify the user's brand field.
  has_many :stations, dependent: :destroy
  #=>I consider a station cannot change its brand. If brand destroyed, it destroys its stations. If station changes brand it would mean destroying and creating a station like changing its company name(raison sociale).
end
