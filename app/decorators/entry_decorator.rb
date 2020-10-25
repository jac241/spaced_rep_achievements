class EntryDecorator < ApplicationDecorator
  delegate_all

  def username
    object.user.try(:username)
  end
end
