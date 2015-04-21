class EmergenciesController < ApplicationController
  def create
    emergency = Emergency.create(
      params
        .require(:emergency)
        .permit(:code, :fire_severity, :police_severity, :medical_severity)
    )

    if emergency.save
      render json: emergency.to_json, status: 201
    else
      render json: { message: emergency.errors }.to_json, status: 422
    end
  end

  def update
    # Get emergency and make sure it is not nil
    emergency = search_for_emergency_by_code
    return if emergency.blank?

    # Update emergency
    emergency.attributes =
      params
      .require(:emergency)
      .permit(
        :fire_severity,
        :police_severity,
        :medical_severity,
        :resolved_at
      )
    # Respond either with emergency or with error messages.
    if emergency.save
      render json: emergency.to_json, status: 200
    else
      render json: { message: emergency.errors }.to_json, status: 422
    end
  end

  private

  def search_for_emergency_by_code
    emergency = Emergency.where(code: params.require(:code)).first
    # Respond to request if empty and return emergency
    render json: {}.to_json, status: 404 if emergency.blank?
    emergency
  end
end
