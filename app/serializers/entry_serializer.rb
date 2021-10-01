class EntrySerializer < ApplicationSerializer
  attributes :score, :updated_at

  belongs_to :reified_leaderboard
  belongs_to :user

  attribute :online do |object|
    object.updated_at > 2.minutes.ago
  end

  has_many :top_medals, serializer: MedalStatisticSerializer

  TYPICAL_OPTIONS_FOR_BROADCAST = {
    include: [ :user ],
    fields: { user: [:username, :updated_at] },
  }

  cache_options store: MemoryCache
end
