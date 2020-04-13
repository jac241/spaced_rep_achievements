module Api
  module V1
    class SyncsController < ApiController
      def create
        # save json file, launch jorb
        results = SynchronizeClientService.call(
          user: current_user, sync_params: create_params
        )

        results.on(:created) { |sync| render json: sync, status: :created }
        results.on(:invalid_params) { |sync| render json: sync.errors, status: :unprocessible_entity }
      end

      private

      def create_params
        params.permit(:client_uuid, :achievements_file)
      end
    end
  end
end
