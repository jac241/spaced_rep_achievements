class MedalSerializer
  include JSONAPI::Serializer
  attributes :name, :score

  belongs_to :family
  has_many :medal_statistics
end
