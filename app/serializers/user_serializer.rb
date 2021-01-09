class UserSerializer < ApplicationSerializer
  attributes :username

  has_many :groups
end
