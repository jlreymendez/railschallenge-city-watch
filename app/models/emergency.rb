class Emergency < ActiveRecord::Base
  validates :code, uniqueness: true, presence: true
  validates(
    :fire_severity,
    :police_severity,
    :medical_severity,
    presence: true,
    numericality: { only_integers: true, greater_than_or_equal_to: 0 }
  )

  def as_json(_options = nil)
    {
      code: code,
      fire_severity: fire_severity,
      police_severity: police_severity,
      medical_severity: medical_severity,
      resolved_at: resolved_at
    }
  end
end
