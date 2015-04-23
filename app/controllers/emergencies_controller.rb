class EmergenciesController < ApplicationController
  def create
    emergency = Emergency.create(
      params
        .require(:emergency)
        .permit(:code, :fire_severity, :police_severity, :medical_severity)
    )

    if emergency.save
      render json: { emergency: emergency }.to_json, status: 201
    else
      render json: { message: emergency.errors }.to_json, status: 422
    end
  end

  def index
    render json: { emergencies: Emergency.all }.to_json, status: 200
  end

  def show
    emergency = search_for_emergency_by_code

    render json: { emergency: emergency }.to_json, status: 200 unless emergency.blank?
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
      render json: { emergency: emergency }.to_json, status: 200
    else
      render json: { message: emergency.errors }.to_json, status: 422
    end
  end

  private

  def search_for_emergency_by_code
    emergency = Emergency.where(code: params.require(:code)).first
    # Raise routing error if emergency wasn't found.
    fail ActionController::RoutingError, params[:code] if emergency.blank?
    # Return emergency
    emergency
  end
end
