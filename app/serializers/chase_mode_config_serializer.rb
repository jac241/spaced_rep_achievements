class ChaseModeConfigSerializer < ApplicationSerializer
  attributes :only_show_active_users
  attribute :group_ids do |object|
    object.group_ids.map(&:to_s)
  end
  belongs_to :user
end
