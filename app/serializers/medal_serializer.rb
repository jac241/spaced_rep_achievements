class MedalSerializer < ApplicationSerializer
  extend ApplicationHelper
  extend ActionView::Helpers::AssetUrlHelper
  attributes :name, :score, :updated_at

  attribute :image_path do |medal|
    medal_image_path(medal)
  end

  belongs_to :family
  has_many :medal_statistics

  cache_options store: MemoryCache
end
