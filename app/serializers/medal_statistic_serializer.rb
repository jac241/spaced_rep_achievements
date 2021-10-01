class MedalStatisticSerializer < ApplicationSerializer
  attributes :count, :score, :updated_at

  belongs_to :entry
  belongs_to :medal

  TYPICAL_OPTIONS_FOR_BROADCAST = {
    include: [ :entry, "entry.user", :medal ],
    fields: {
      user: [:username],
      medal: [:name, :score, :image_path]
    },
  }

  cache_options store: MemoryCache
end
