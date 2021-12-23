class UserSerializer < ApplicationSerializer
  attributes :username, :updated_at

  has_many :groups
  has_many :memberships

  cache_options store: MemoryCache
end
