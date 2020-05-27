class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :masquerade_user!

  # for devise_token_auth_controllers
  skip_before_action :verify_authenticity_token, if: :devise_token_auth?

  def devise_token_auth?
    controller_path.start_with?('devise_token_auth/')
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end
end
