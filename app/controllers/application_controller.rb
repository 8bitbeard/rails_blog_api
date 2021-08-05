class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?

rescue_from ActiveRecord::RecordNotFound, with: :show_not_found_errors

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name nickname])
  end

  def show_not_found_errors(exception)
    render json: {
      code: "NOT_FOUND",
      message: "Article not found",
      details: [
        "Article not found"
      ]
    }, status: :not_found
  end
end
