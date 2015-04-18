class RespondersController < ApplicationController
  def create
    responder = Responder.create(params.require(:responder).permit(:type, :name, :capacity))
    @response = generate_response(responder)

    if responder.save
      render json: @response.to_json, status: 201
    else
      render json: {}.to_json, status: 422
    end
  end

  private

  def generate_response(responder = {})
    {
      responder: {
        name: responder.name,
        type: responder.type,
        emergency_code: responder.emergency_code,
        capacity: responder.capacity,
        on_duty: responder.on_duty
      }
    }
  end
end
