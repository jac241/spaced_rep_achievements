class PingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    ActionCable.server.broadcast('ping_channel', "Hello at #{Time.now}")
  end
end
