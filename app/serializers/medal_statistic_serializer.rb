class MedalStatisticSerializer
  include JSONAPI::Serializer
  attributes :count, :score

  belongs_to :reified_leaderboard
  belongs_to :user
  belongs_to :medal
end
