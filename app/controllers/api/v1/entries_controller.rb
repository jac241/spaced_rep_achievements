module Api
  module V1
    class EntriesController < ApiController
      before_action :authenticate_user!

      def index
        entries =
          Entry
          .includes(*includes)
          .where(index_params.except(:updated_since))
          .where('score > 0')

        if index_params[:updated_since]
          entries = entries.where('updated_at > ?',
                                  index_params[:updated_since])
        end
        render json: EntrySerializer.new(entries, include: serializer_includes,
                                                  fields: fields)
      end

      private

      def includes
        [{ user: { memberships: :group } }].tap do |i|
          if includes_contains?('top_medals')
            i << { top_medals: { medal: [:family] } }
          end
        end
      end

      def fields
        if includes_contains?('top_medals')
          {
            user: %i[username updated_at],
            medal: %i[image_path updated_at]
          }
        else
          {
            user: %i[username updated_at],
            entry: %i[score updated_at user online]
          }
        end
      end

      def includes_contains?(key)
        params[:include].try(:split, ',').try(:include?, key)
      end

      def serializer_includes
        [:user].tap do |i|
          if includes_contains?('top_medals')
            i << 'top_medals'
            i << 'top_medals.medal'
            i << 'user.groups'
          else
            i << 'user.memberships'
          end
        end
      end

      def index_params
        params.permit(:reified_leaderboard_id, :updated_since)
      end
    end
  end
end
