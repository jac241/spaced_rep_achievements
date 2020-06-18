module Api
  module V1
    class SyncsController < ApiController
      before_action :authenticate_user!

      def create
        # save json file, launch jorb
        results = SynchronizeClientService.call(
          user: current_user, sync_params: create_params
        )

        results.on(:created) { |sync| render json: sync, status: :created }
        results.on(:invalid_params) { |sync| render json: sync.errors, status: :unprocessible_entity }
      end

      def index
        render json: current_user.syncs.order(created_at: :asc).last(5)
      end

      private

      def create_params
        params.permit(:client_uuid, :achievements_file)
      end
    end
  end
end
