module Api
  module V1
    class RivalriesController < ApiController
      before_action :auth_by_token!

      def show
        result = FindRivalryService.call(
          user: current_token_user,
          family_slug: params[:id]
        )

        result.on(:found) do |rivalry|
          @rivalry = rivalry
        end
      end
    end
  end
end
