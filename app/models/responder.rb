class Responder < ActiveRecord::Base
  self.inheritance_column = nil

  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: { in: 1..5 }
  validates :type, presence: true

  before_save :default_values

  RESOURCES_TYPE = %w(Fire Police Medical)

  scope(:of_type, -> (type) { where(type: type) })
  scope(:on_duty, -> { where(on_duty: true) })
  scope(:available, -> { where(emergency_code: nil) })
  scope(:emergency_ready, -> { available.on_duty  })
  scope(
    :capable_of,
    -> (severity) { where('capacity >= ?', severity).order("capacity - #{severity} asc") }
  )
  scope(
    :in_appropiate_order_for,
    -> (severity) { order("capacity - #{severity} desc") }
  )

  def default_values
    self.on_duty = on_duty.nil? ? false : on_duty
    self
  end

  def as_json(_options = nil)
    {
      name: name,
      type: type,
      emergency_code: emergency_code,
      capacity: capacity,
      on_duty: on_duty
    }
  end

  def self.dispatch_to(emergency = nil)
    return [] if emergency.blank?
    all_types_covered = []

    RESOURCES_TYPE.each do |type|
      type_severity = emergency["#{type.downcase}_severity"]
      next if type_severity <= 0

      type_covered = find_best_match(emergency.code, type, type_severity)

      unless type_covered
        type_covered = find_matches(emergency.code, type, type_severity)
      end

      all_types_covered << type_covered
    end

    emergency.update(full_response: true) if all_types_covered.all?
  end

  def self.full_capacity
    full_capacity = {}
    RESOURCES_TYPE.each do |type|
      full_capacity[type] = capacity_of_type(type)
    end
    full_capacity
  end

  def self.capacity_of_type(type = '')
    resources_of_type = of_type(type)
    [
      resources_of_type.sum(:capacity),
      resources_of_type.available.sum(:capacity),
      resources_of_type.on_duty.sum(:capacity),
      resources_of_type.emergency_ready.sum(:capacity)
    ]
  end

  def self.find_best_match(code, type, severity)
    best_match = of_type(type).emergency_ready.capable_of(severity).first

    if !best_match.blank?
      best_match.update(emergency_code: code)
      best_match.save
      true
    else
      false
    end
  end

  def self.find_matches(code, type, severity)
    responders = of_type(type).emergency_ready.in_appropiate_order_for(severity)

    responders.each do |responder|
      severity -= responder.capacity
      responder.update(emergency_code: code)
      responder.save
      break unless severity > 0
    end

    severity <= 0
  end
end
