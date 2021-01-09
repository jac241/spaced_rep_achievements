class ReifiedLeaderboardSerializer < ApplicationSerializer
  belongs_to :family

  has_many :entries do |record, params|
    record.entries
      .where("updated_at > ? AND score > 0", params[:data_since])
      .includes(user: [ :groups ])
  end

  has_many :medal_statistics do |record, params|
    @_medal_statistics ||=
      MedalStatistic
        .top_medals
        .where("updated_at > ?", params[:data_since])
        .where("reified_leaderboard_id = ?", record.id)
        .includes(:medal)
  end

  attributes :timeframe
end
