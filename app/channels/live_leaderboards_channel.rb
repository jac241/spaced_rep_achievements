class LiveLeaderboardsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "leaderboard:#{params[:leaderboard]}"
    # Any cleanup needed when channel is unsubscribed
  end
end
