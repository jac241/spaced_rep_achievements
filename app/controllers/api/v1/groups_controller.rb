module Api
  module V1
    class GroupsController < ApiController
      def index
        groups = Group.where(index_params)

        render json: GroupSerializer.new(groups)
      end

      private

      def index_params
        params.permit(id: [])
      end
    end
  end
end
