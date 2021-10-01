class GroupSerializer < ApplicationSerializer
  attributes :tag, :color, :tag_text_color, :updated_at

  cache_options store: MemoryCache
end
