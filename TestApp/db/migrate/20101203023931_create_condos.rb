class CreateCondos < ActiveRecord::Migration
  def self.up
    create_table :condos do |t|
      t.text :name
      t.integer :price
      t.integer :area
      t.integer :number_of_bedrooms
      t.integer :price_per_square_feet
      t.integer :agent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :condos
  end
end
