class GroupSerializer < ApplicationSerializer
  attributes :tag, :color, :tag_text_color

  cache_with_default_options
end
