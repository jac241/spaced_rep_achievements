module Api
  module V1
    class EntriesController < ApiController
      before_action :auth_by_token!

      def index
        entries = Entry.includes(:user).where(index_params.except(:updated_since))

        if index_params[:updated_since]
          entries = entries.where("updated_at > ?", index_params[:updated_since])
        end

        render json: EntrySerializer.new(entries, include: [:user]).serializable_hash
      end

      private

      def index_params
        params.permit(:reified_leaderboard_id, :updated_since)
      end
    end
  end
end
