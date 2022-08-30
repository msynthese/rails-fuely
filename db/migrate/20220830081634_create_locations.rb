class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :adress
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
