class ChangeBrandToReferenceInUsersTable < ActiveRecord::Migration[7.0]
  def change
    remove_column(:users, :brand_preference)
    add_reference(:users, :brand, foreign_key: true)
  end
end
