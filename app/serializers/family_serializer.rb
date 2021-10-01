class FamilySerializer < ApplicationSerializer
  attributes :name, :slug

  cache_options store: MemoryCache
end
