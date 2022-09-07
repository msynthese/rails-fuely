class ModifyCapacityToUser < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :capacity, 0
  end
end
