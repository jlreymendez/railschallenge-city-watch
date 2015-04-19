class RespondersController < ApplicationController
  def create
    strong_params = params.require(:responder).permit(:type, :name, :capacity)

    responder = Responder.create(strong_params)
    response = generate_response(responder)

    if responder.save
      render json: response.to_json, status: 201
    else
      render json: response.to_json, status: 422
    end
  end

  private

  def generate_response(responder = {})
    if responder.blank?
      return {}
    end

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
