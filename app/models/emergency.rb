class Emergency < ActiveRecord::Base
  has_many :responders, foreign_key: :emergency_code, primary_key: :code

  validates :code, uniqueness: true, presence: true
  validates(
    :fire_severity,
    :police_severity,
    :medical_severity,
    presence: true,
    numericality: { only_integers: true, greater_than_or_equal_to: 0 }
  )

  after_save :dismiss_responders

  scope(:full_responses, -> { where(full_response: true) })

  def as_json(_options = nil)
    {
      code: code,
      fire_severity: fire_severity,
      police_severity: police_severity,
      medical_severity: medical_severity,
      resolved_at: resolved_at,
      responders: responders.pluck('name'),
      full_response: full_response
    }
  end

  private

  def dismiss_responders
    responders.clear if resolved_at
  end
end
