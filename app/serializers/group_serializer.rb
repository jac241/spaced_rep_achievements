class GroupSerializer
  include JSONAPI::Serializer
  attributes :tag, :color, :tag_text_color
end
