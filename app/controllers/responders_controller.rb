class RespondersController < ApplicationController
  def create
    # Verify parameters and create
    responder = Responder.create(params.require(:responder).permit(:type, :name, :capacity))

    # Respond either with responder or with error messages.
    if responder.save
      render json: responder.to_json, status: 201
    else
      render json: { message: responder.errors }.to_json, status: 422
    end
  end

  def show
    # Verify parameters and find responder.
    responder = search_for_named_responder
    # Respond either with responder or with not found message.
    render json: responder.to_json, status: 200 unless responder.blank?
  end

  def update
    # Verify parameters and find.
    responder = search_for_named_responder
    # Make sure it was found before proceeding
    return if responder.blank?

    # Verify parameters and update.
    responder.update(on_duty: params.require(:responder).permit(:on_duty)['on_duty'])
    # Respond either with responder or with error messages.
    if responder.save
      render json: responder.to_json, status: 200
    else
      render json: { message: responder.errors }.to_json, status: 422
    end
  end

  private

  def search_for_named_responder
    responder = Responder.where(name: params.require(:name)).first
    # Respond to request if empty and return responder
    render json: {}.to_json, status: 404 if responder.blank?
    responder
  end
end
