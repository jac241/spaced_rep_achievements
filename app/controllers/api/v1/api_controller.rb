module Api
  module V1
    class ApiController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken

      private
      # Trying to do this manually because we devise the wrong user sometimes!!!
      def auth_by_token!
        unless set_user_by_token
          Rails.logger.info "Unauthorized token user"
          head :unauthorized
        end
      end

      def current_token_user
        @current_token_user ||= set_user_by_token.tap do |user|
          Rails.logger.info "HEADERS uid: #{request.headers["uid"]}"
          Rails.logger.info "set user uid: #{user.uid}"
          Rails.logger.info "set user email: #{user.email}"
        end
      end

      def resource_name
        "User"
      end
    end
  end
end
