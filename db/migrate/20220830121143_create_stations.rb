class CreateStations < ActiveRecord::Migration[7.0]
  def change
    create_table :stations do |t|
      t.string :name
      t.integer :brand
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :city
      t.string :cp
      t.string :fuel
      t.string :shortage
      t.float :price_e10
      t.float :price_e85
      t.float :price_gazole
      t.float :price_sp98
      t.float :price_sp95
      t.float :price_gplc
      t.string :services
      t.string :automate_24_24
      t.date :update
      t.string :dist
      t.string :api_id
      t.string :api_recordid

      t.timestamps
    end
  end
end
