class RealtimeLeaderboardsChannel < ApplicationCable::Channel
  state_attr_accessor :leaderboard

  def subscribed
    self.leaderboard = ReifiedLeaderboard.find(params[:leaderboard_id])

    stream_for self.leaderboard
  end

  def request_data_since(data)
    UpdateRealtimeLeaderboardJob.perform_later(
      leaderboard: self.leaderboard,
      data_since: data["last_updated"],
      should_use_cache: data["should_use_cache"],
    )
  end
end
