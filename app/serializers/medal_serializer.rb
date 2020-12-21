class MedalSerializer
  include JSONAPI::Serializer
  extend ApplicationHelper
  extend ActionView::Helpers::AssetUrlHelper
  attributes :name, :score

  attribute :image_path do |medal|
    medal_image_path(medal)
  end

  belongs_to :family
  has_many :medal_statistics
end
