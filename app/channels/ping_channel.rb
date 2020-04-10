class PingChannel < ApplicationCable::Channel
  def subscribed
     stream_from "ping_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
