class RealtimeLeaderboardsChannel < ApplicationCable::Channel
  state_attr_accessor :leaderboard

  def subscribed
    self.leaderboard = ReifiedLeaderboard.find(params[:leaderboard_id])

    stream_for self.leaderboard

    UpdateRealtimeLeaderboardJob.perform_later(
      leaderboard: self.leaderboard,
      data_since: params[:last_updated]
    )
  end

  def request_data_since(data)
  end
end
