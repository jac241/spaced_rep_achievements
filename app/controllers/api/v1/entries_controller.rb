module Api
  module V1
    class EntriesController < ApiController
      before_action :authenticate_user!

      def index
        entries =
          Entry
            .includes(*includes)
            .where(index_params.except(:updated_since))
            .where("score > 0")

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
         if includes_contains?("top_medals")
           {
             user: [ :username, :updated_at ],
             medal:  [ :image_path, :updated_at ],
           }
         else
          {
            user: [ :username, :updated_at ],
            entry: [ :score, :updated_at, :user, :online ],
          }
         end
      end

      def includes_contains?(key)
        params[:include].try(:split, ',').try(:include?, key)
      end

      def serializer_includes
        [:user].tap do |i|
           if includes_contains?("top_medals")
             i << "top_medals"
             i << "top_medals.medal"
             i << "user.groups"
           end
        end
      end

      def index_params
        params.permit(:reified_leaderboard_id, :updated_since)
      end
    end
  end
end
