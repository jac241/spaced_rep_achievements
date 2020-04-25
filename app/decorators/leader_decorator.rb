class LeaderDecorator < ApplicationDecorator
  delegate_all

  def username
    object.user.username
  end
end
