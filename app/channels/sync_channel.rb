class SyncChannel < ApplicationCable::Channel
  def subscribed
    stream_from "sync:#{stream_name}"
    # Any cleanup needed when channel is unsubscribed
  end

  def start_sync
    SyncChannel.broadcast_to(stream_name, since_datetime: Time.now)
  end

  private

  def stream_name
    "syncing:#{syncing_user.token}"
  end

  def syncing_user
    current_user || token_user
  end
end
