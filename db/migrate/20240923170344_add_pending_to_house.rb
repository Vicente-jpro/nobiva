class AddPendingToHouse < ActiveRecord::Migration[7.1]
  def change
    add_column :houses, :pending, :boolean, default: true
  end
end
