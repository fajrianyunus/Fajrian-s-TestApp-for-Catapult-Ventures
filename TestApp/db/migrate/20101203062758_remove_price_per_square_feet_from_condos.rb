class RemovePricePerSquareFeetFromCondos < ActiveRecord::Migration
  def self.up
    remove_column :condos, :price_per_square_feet
  end

  def self.down
    add_column :condos, :price_per_square_feet, :integer
  end
end
