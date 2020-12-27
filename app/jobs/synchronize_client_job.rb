class SynchronizeClientJob < ApplicationJob
  include ActiveSupport::Benchmarkable

  queue_as :sync

  def perform(sync)
    client_uuid = sync.client_uuid # don't want to call this 20,000 times...
    user_id = sync.user_id

    achievements = benchmark 'Unzip and prepare achievement attributes' do
      sync.achievements_file
        .download
        .then { |file| Zlib::Inflate.inflate(file) }
        .then { |json| JSON.parse(json) }
        .map do |a|
          prepare_attrs(achievement_attrs: a, client_uuid: client_uuid, user_id: user_id)
        end
    end

    ApplicationRecord.transaction do
      # let's us overwrite records that already exist, full sync will be the
      # ground truth. The requests that will come each time you earn a medal
      # reviewing will just be temporary
      benchmark 'Write achievements to database' do
        ApplicationRecord.logger.silence do
          sync.achievements.import!(
            achievements,
            on_duplicate_key_update: {
              conflict_target: [:client_uuid, :client_db_id, :client_earned_at],
              columns: [:sync_id]
            }
          )
        end
      end
      sync.achievements_file.purge
    end
  end

  private

  def prepare_attrs(achievement_attrs:, client_uuid:, user_id:)
    {
      medal_id: all_medal_ids_by_client_medal_id[achievement_attrs["medal_id"]],
      client_uuid: client_uuid,
      client_db_id: achievement_attrs["id_"],
      client_medal_id: achievement_attrs["medal_id"],
      client_deck_id: achievement_attrs["deck_id"],
      client_earned_at: achievement_attrs["created_at"],
      user_id: user_id,
    }
  end

  # actually care about speed cuz server only has 1 CPU...
  def all_medal_ids_by_client_medal_id
    @all_medal_ids_by_client_medal_id ||=
      Medal.select(:id, :client_medal_id).all
        .each_with_object({}) do |medal, hash|
          hash[medal.client_medal_id] = medal.id
        end
  end
end

