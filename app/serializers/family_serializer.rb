class FamilySerializer
  include JSONAPI::Serializer
  attributes :name, :slug
end
