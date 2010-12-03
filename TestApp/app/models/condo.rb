class Condo < ActiveRecord::Base
  belongs_to :agent

  validates_length_of :name, :minimum => 1, :allow_nil => false
  validates_numericality_of :area, :greater_than_or_equal_to => 0
  validates_numericality_of :number_of_bedrooms, :greater_than_or_equal_to => 0
  validates_numericality_of :price_per_square_feet, :greater_than_or_equal_to => 0

  before_save :strip_input

  def self.get_all(order_by_command=nil)

    db_result = nil
    if (order_by_command.nil?)
      db_result = Condo.find(:all)
    else
      db_result = Condo.find(:all, :order => order_by_command)
    end

    db_result.each { |entry|
      entry.name = entry.name.upcase
      entry[:price] = entry.price_per_square_feet * Float(entry.area)
      entry.agent.name = entry.agent.name.upcase unless (entry.agent.nil? || entry.agent.name.nil?)
    }

    return db_result
  end

  def self.get_all_an_agent_condo(agent_id)
    begin
      agent_id = Integer(agent_id)
    rescue
      return []
    end

    agent = Agent.find(agent_id)
    if (agent.nil?)
      return []
    end
    
    db_result = agent.condos
    agent.name = agent.name.upcase unless agent.name.nil?

    db_result.each { |entry|
      entry.name = entry.name.upcase
      entry[:price] = entry.price_per_square_feet * Float(entry.area)
      
    }

    return db_result
  end

  def self.delete_a_tuple(condo_id)
    begin
      condo_id = Integer(condo_id)
    rescue
      return false
    end

    condo = Condo.find(condo_id)

    if (condo.nil?)
      return false
    end
    
    its_agent = condo.agent

    condo.delete

    if (!its_agent.nil? && its_agent.condos.length == 0)
      its_agent.delete
    end

    return true
  end

  protected
  def strip_input
    self.name = self.name.strip unless self.name.nil?
    self.name = nil if self.name.length == 0
    self.name = self.name.downcase unless self.name.nil?
  end
end
