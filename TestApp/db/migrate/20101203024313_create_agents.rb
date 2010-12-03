class CreateAgents < ActiveRecord::Migration
  def self.up
    create_table :agents do |t|
      t.text :name
      t.text :phone_number

      t.timestamps
    end
  end

  def self.down
    drop_table :agents
  end
end
