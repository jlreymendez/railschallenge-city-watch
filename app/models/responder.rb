class Responder < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  before_save :default_values

  def default_values
    self.on_duty = on_duty.nil? ? false : on_duty
    self
  end
end
