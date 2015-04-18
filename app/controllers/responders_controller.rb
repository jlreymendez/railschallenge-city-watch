class RespondersController < ApplicationController
  rescue_from(ActionController::UnpermittedParameters) do |unpermitted_parameters|
    message = { message: unpermitted_parameters.message }
    render json: message.to_json, status: 422
  end

  def create
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    strong_params = params.require(:responder).permit(:type, :name, :capacity)

    responder = Responder.create(strong_params)
    @response = generate_response(responder)

    if responder.save
      render json: @response.to_json, status: 201
    else
      render json: @response.to_json, status: 422
    end
  end

  private

  def generate_response(responder = {})
    if responder.save
      {
        responder: {
          name: responder.name,
          type: responder.type,
          emergency_code: responder.emergency_code,
          capacity: responder.capacity,
          on_duty: responder.on_duty
        }
      }
    else
      {
        message: responder.errors
      }
    end
  end
end
