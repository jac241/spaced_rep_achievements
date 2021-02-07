module Api
  module V1
    class EntriesController < ApiController
      before_action :auth_by_token!

      def index
        entries = Entry.includes(:user).where(index_params)

        render json: EntrySerializer.new(entries, include: [:user]).serializable_hash
      end

      private

      def index_params
        params.permit(:reified_leaderboard_id)
      end
    end
  end
end
