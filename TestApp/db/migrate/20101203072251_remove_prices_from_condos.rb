class RemovePricesFromCondos < ActiveRecord::Migration
  def self.up
    remove_column :condos, :price
  end

  def self.down
    add_column :condos, :price, :integer
  end
end
