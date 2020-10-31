class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # for devise_token_auth_controllers. Need to figure out how to make DeviseTokenAuth use a different base controller
  skip_before_action :verify_authenticity_token, if: :devise_token_auth?

  def devise_token_auth?
    controller_path.start_with?('devise_token_auth/')
  end
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
