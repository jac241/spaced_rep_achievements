module Api
  module V1
    class EntriesController < ApiController
      before_action :authenticate_user!

      def index
        entries = Entry.includes(*includes).where(index_params.except(:updated_since))

        if index_params[:updated_since]
          entries = entries.where("updated_at > ?", index_params[:updated_since])
        end
        render json: EntrySerializer.new(entries, include: serializer_includes, fields: fields)
      end

      private

      def includes
        [{ user: :groups }].tap do |i|
          i << { top_medals: { medal: [ :family ] } } if includes_contains?("top_medals")
        end
      end

      def fields
        { user: [:username] }.tap do |f|
           if includes_contains?("top_medals")
             f[:medal] = [ :image_path ]
           end
        end
      end

      def includes_contains?(key)
        params[:include].try(:split, ',').try(:include?, key)
      end

      def serializer_includes
        [:user, "user.groups"].tap do |i|
           if includes_contains?("top_medals")
             i << "top_medals"
             i << "top_medals.medal"
           end
        end
      end

      def index_params
        params.permit(:reified_leaderboard_id, :updated_since)
      end
    end
  end
end
