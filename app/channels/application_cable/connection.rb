module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :token_user, :uuid

    def connect
      self.uuid = SecureRandom.urlsafe_base64
      logger.add_tags "ActionCable", "Connecting..."
      self.current_user = find_verified_user

      unless self.current_user
        if request.params[:user_token]
          self.token_user = User.first
        end
      end
    end

    protected

      def find_verified_user
        app_cookies_key = Rails.application.config.session_options[:key] ||
          raise("No session cookies key in config")

        env["rack.session"] = cookies.encrypted[app_cookies_key]
        Warden::SessionSerializer.new(env).fetch(:user)
      end
  end
end
