class RealtimeLeaderboardsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:leaderboard]}"
    Rails.logger.debug params[:last_updated]
    # Any cleanup needed when channel is unsubscribed
  end
end
