class AddPricePerSquareFeetToCondos < ActiveRecord::Migration
  def self.up
    add_column :condos, :price_per_square_feet, :float
  end

  def self.down
    remove_column :condos, :price_per_square_feet
  end
end
