class ChangeBrandToReferenceInStationsTable < ActiveRecord::Migration[7.0]
  def change
    remove_column(:stations, :brand)
    add_reference(:stations, :brand, foreign_key: true)
  end
end
