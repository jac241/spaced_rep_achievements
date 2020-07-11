class DestroyUserJob < ApplicationJob
  queue_as :sync

  def perform(user_id)
    user = User.find(user_id)
    user.destroy!
  end
end
