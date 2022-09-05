class AddCapacityToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :capacity, :integer
  end
end
