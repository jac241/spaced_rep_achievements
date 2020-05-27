
module Api
  module V1
    class UsersController < ApiController
      def current
        head :no_content
      end
    end
  end
end
