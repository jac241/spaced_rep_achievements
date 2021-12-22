class ChaseModeConfigSerializer < ApplicationSerializer
  attributes :only_show_active_users
  belongs_to :user
end
