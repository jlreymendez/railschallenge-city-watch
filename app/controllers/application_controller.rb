class ApplicationController < ActionController::Base
  before_action :unpermitted_parameters_check

  rescue_from(ActionController::UnpermittedParameters) do |unpermitted_parameters|
    message = { message: unpermitted_parameters.message }
    render json: message.to_json, status: 422
  end

  def unpermitted_parameters_check
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end
end
