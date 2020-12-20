class RealtimeLeaderboardsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:leaderboard]}"
    # Any cleanup needed when channel is unsubscribed
  end
end
