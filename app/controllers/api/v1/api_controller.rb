module Api
  module V1
    class ApiController < ActionController::Base
      skip_before_action :verify_authenticity_token
      before_action :authenticate

      private

      def authenticate
        authenticate_or_request_with_http_token do |token, _|
          # Timing Attac
          User.find_by(token: token)
        end
      end

      def current_user
        @current_user ||= authenticate
      end
    end
  end
end
