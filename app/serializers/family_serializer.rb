class FamilySerializer < ApplicationSerializer
  attributes :name, :slug

  cache_with_default_options
end
