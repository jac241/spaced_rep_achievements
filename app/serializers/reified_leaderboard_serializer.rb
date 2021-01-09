class ReifiedLeaderboardSerializer < ApplicationSerializer
  belongs_to :family

  has_many :entries do |record, params|
    record.entries
      .where("updated_at > ? AND score > 0", params[:data_since])
      .includes(user: [ :groups ])
  end
  has_many :medal_statistics do |record, params|
    record.medal_statistics
      .where("updated_at > ? AND count > 0", params[:data_since])
      .order(score: :desc)
      .includes(:medal)
  end

  attributes :timeframe
end
