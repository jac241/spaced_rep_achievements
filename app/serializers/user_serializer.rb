class UserSerializer
  include JSONAPI::Serializer
  attributes :username

  has_many :groups
end
