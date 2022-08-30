class ChangeLocationAdressToAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column(:locations, :adress, :address)
  end
end
