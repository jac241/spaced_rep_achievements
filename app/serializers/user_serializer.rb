class UserSerializer < ApplicationSerializer
  attributes :username, :updated_at

  has_many :groups
end
