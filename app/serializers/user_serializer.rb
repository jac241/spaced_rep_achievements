class UserSerializer < ApplicationSerializer
  attributes :username, :updated_at

  has_many :groups

  cache_options store: MemoryCache
end
