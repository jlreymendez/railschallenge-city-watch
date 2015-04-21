class Emergency < ActiveRecord::Base
  validates :code, uniqueness: true, presence: true
  validates(
    :fire_severity,
    :police_severity,
    :medical_severity,
    presence: true,
    numericality: { only_integers: true, greater_than_or_equal_to: 0 }
  )
end
