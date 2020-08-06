module Api
  module V1
    class ApiController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken
      skip_after_action :update_auth_header
      after_action :update_auth_header_and_log

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
          Rails.logger.info "REQUEST HEADERS uid: #{request.headers["uid"]}"
          Rails.logger.info "set user uid: #{user.uid}"
          Rails.logger.info "set user email: #{user.email}"
          if request.headers["uid"] != user.uid
            Rails.logger.critical "WRONG USER LOADED!"
          end
        end
      end

      def resource_name
        "User"
      end

      def update_auth_header_and_log
        update_auth_header()
        Rails.logger.info "RESPONSE HEADERS uid: #{response.headers["uid"]}"
        if request.headers["uid"] != response.headers["uid"]
          Rails.logger.critical "WRONG USER RETURNED!"
        end
      end
    end
  end
end
