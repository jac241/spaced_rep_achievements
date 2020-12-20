class ReifiedLeaderboardSerializer
  include JSONAPI::Serializer
  belongs_to :family
  has_many :entries
  has_many :medal_statistics

  attributes :timeframe
end
