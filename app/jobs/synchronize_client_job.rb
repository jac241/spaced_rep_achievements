class SynchronizeClientJob < ApplicationJob
  queue_as :default

  def perform(sync)
    client_uuid = sync.client_uuid # don't want to call this 20,000 times...

    achievements = sync.achievements_file
      .download
      .then { |file| Zlib::Inflate.inflate(file) }
      .then { |json| JSON.parse(json) }
      .map { |a| prepare_attrs(achievement_attrs: a, client_uuid: client_uuid) }

    ApplicationRecord.transaction do
      # let's us overwrite records that already exist, full sync will be the
      # ground truth. The requests that will come each time you earn a medal
      # reviewing will just be temporary
      ApplicationRecord.logger.silence do
        sync.achievements.import!(achievements, on_duplicate_key_ignore: true)
      end
      sync.achievements_file.purge
    end
  end

  private

  def prepare_attrs(achievement_attrs:, client_uuid:)
    {
      client_uuid: client_uuid,
      client_db_id: achievement_attrs["id_"],
      client_medal_id: achievement_attrs["medal_id"],
      client_deck_id: achievement_attrs["deck_id"],
      client_earned_at: achievement_attrs["created_at"],
    }
  end
end

