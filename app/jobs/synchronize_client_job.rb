class SynchronizeClientJob < ApplicationJob
  queue_as :default

  def perform(sync)
    sync.achievements_file
      .download
      .then { |file| Zlib::Inflate.inflate(file) }
      .then { |json| JSON.parse(json) }
      .first(5).each { |a| Rails.logger.info(a) }

    sync.achievements_file.purge
  end
end
