class MedalStatisticSerializer < ApplicationSerializer
  attributes :count, :score

  belongs_to :reified_leaderboard
  belongs_to :user
  belongs_to :medal

  TYPICAL_OPTIONS_FOR_BROADCAST = {
    include: [ :user, :medal ],
    fields: {
      user: [:username],
      medal: [:name, :score, :image_path]
    },
  }

  cache_with_default_options
end
