class EmergenciesController < ApplicationController
  def create
    strong_params = params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)

    emergency = Emergency.create(strong_params)
    response = generate_response(emergency)

    if emergency.save
      render json: response.to_json, status: 201
    else
      render json: response.to_json, status: 422
    end
  end

  private

  def generate_response(emergency = {})
    return {} if emergency.blank?

    if emergency.save
      {
        emergency: {
          code: emergency.code,
          fire_severity: emergency.fire_severity,
          police_severity: emergency.police_severity,
          medical_severity: emergency.medical_severity
        }
      }
    else
      {
        message: emergency.errors
      }
    end
  end
end
