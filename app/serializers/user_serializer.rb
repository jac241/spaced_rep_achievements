class UserSerializer < ApplicationSerializer
  attributes :username

  has_many :groups

  cache_with_default_options
end
