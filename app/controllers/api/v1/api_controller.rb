module Api
  module V1
    class ApiController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken
      skip_after_action :update_auth_header, unless: -> { @used_auth_by_token }

      private
      def auth_by_token!
        unless set_user_by_token
          Rails.logger.info "Unauthorized token user"
          head :unauthorized
        end
      end

      def current_token_user
        @current_token_user ||= set_user_by_token
      end

      def resource_name
        "User"
      end
    end
  end
end
