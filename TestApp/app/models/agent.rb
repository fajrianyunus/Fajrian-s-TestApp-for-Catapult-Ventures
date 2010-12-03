class Agent < ActiveRecord::Base
  has_many :condos

  validates_length_of :name, :minimum => 1, :allow_nil => false
  validates_length_of :phone_number, :minimum => 1, :allow_nil => true

  before_save :strip_input

  protected
  def strip_input
    self.name = self.name.strip unless self.name.nil?
    self.name = nil if self.name.length == 0
    self.name = self.name.downcase unless self.name.nil?

    self.phone_number = self.phone_number.strip unless self.phone_number.nil?
    self.phone_number = nil if self.phone_number.length == 0
  end
end
