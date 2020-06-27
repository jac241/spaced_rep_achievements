module Api
  module V1
    class RivalriesController < ApiController
      before_action :authenticate_user!

      def show
        result = FindRivalryService.call(
          user: current_user,
          family_slug: params[:id]
        )

        result.on(:found) do |rivalry|
          @rivalry = rivalry

          respond_to do |format|
            format.html
          end
        end
      end
    end
  end
end
