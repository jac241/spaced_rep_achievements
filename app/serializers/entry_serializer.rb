class EntrySerializer
  include JSONAPI::Serializer
  attributes :score, :updated_at

  belongs_to :reified_leaderboard
  belongs_to :user

  TYPICAL_OPTIONS_FOR_BROADCAST = {
    include: [ :user ],
    fields: { user: [:username] },
  }
end
