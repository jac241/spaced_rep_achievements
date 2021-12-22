module Api
  module V1
    class ChaseModeConfigsController < ApiController
      before_action :authenticate_user!

      def show
        chase_mode_config = current_user.chase_mode_config

        render json: ChaseModeConfigSerializer.new(chase_mode_config)
      end
    end
  end
end
