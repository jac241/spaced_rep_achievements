require "administrate/base_dashboard"

class MedalStatisticDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    entry: Field::BelongsTo,
    medal: Field::BelongsTo,
    id: Field::Number,
    reified_leaderboard_id: Field::String,
    count: Field::Number,
    score: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    instance_count_delta: Field::Number,
    instance_score_delta: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  entry
  medal
  id
  score
  count
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  entry
  medal
  id
  reified_leaderboard_id
  count
  score
  created_at
  updated_at
  instance_count_delta
  instance_score_delta
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  entry
  medal
  reified_leaderboard_id
  count
  score
  instance_count_delta
  instance_score_delta
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how medal statistics are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(medal_statistic)
  #   "MedalStatistic ##{medal_statistic.id}"
  # end
end
