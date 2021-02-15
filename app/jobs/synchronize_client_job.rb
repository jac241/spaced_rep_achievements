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
          prepare_attrs(
            achievement_attrs: a,
            client_uuid: client_uuid,
            user_id: user_id,
          )
        end
    end

    # let's us overwrite records that already exist, full sync will be the
    # ground truth. The requests that will come each time you earn a medal
    # reviewing will just be temporary
    services_results = benchmark 'Write achievements to database', silence: true do
      ApplicationRecord.transaction do
        imported_ids = import_achievements!(sync, achievements)

        services_results = find_new_achievements_created_in_this_sync(imported_ids).map do |achievement|
          AfterAchievementCreatedService.call(
            achievement: achievement,
            user: sync.user
          )
        end
      end
    end

    sync.achievements_file.purge_later

    unless services_results.empty?
      BroadcastLeaderboardUpdatesJob.perform_later(
        medal_statistics: services_results.map(&:body).flat_map(&:medal_statistics)
      )
    end
  end

  private

  def prepare_attrs(achievement_attrs:, client_uuid:, user_id:)
    attrs = {
      medal_id: all_medal_ids_by_client_medal_id[achievement_attrs["medal_id"]],
      client_uuid: client_uuid,
      client_db_id: achievement_attrs["id_"],
      client_medal_id: achievement_attrs["medal_id"],
      client_deck_id: achievement_attrs["deck_id"],
      client_earned_at: achievement_attrs["created_at"],
      user_id: user_id,
    }
    attrs[:client_db_uuid] = achievement_attrs["uuid"] if achievement_attrs["uuid"]

    attrs
  end

  # actually care about speed cuz server only has 1 CPU...
  def all_medal_ids_by_client_medal_id
    @all_medal_ids_by_client_medal_id ||=
      Medal.select(:id, :client_medal_id).all
        .each_with_object({}) do |medal, hash|
          hash[medal.client_medal_id] = medal.id
        end
  end

  def import_achievements!(sync, achievements)
    as_with_uuid, as_without_uuid = achievements.partition { |a| a[:client_db_uuid].present? }

    with_uuid_result = sync.achievements.import!(
      as_with_uuid,
      on_duplicate_key_update: {
        conflict_target: [:client_db_uuid],
        columns: [:sync_id]
      }
    )

    without_uuid_result = sync.achievements.import!(
      as_without_uuid,
      on_duplicate_key_update: {
        conflict_target: [:client_uuid, :client_db_id, :client_earned_at],
        columns: [:sync_id]
      }
    )

    with_uuid_result.ids.concat(without_uuid_result.ids)
  end

  def find_new_achievements_created_in_this_sync(imported_ids)
    achievements_with_expirations =
      Expiration
      .where(achievement_id: imported_ids)
      .pluck(:achievement_id)

    new_achievement_ids =
      Set.new(imported_ids) - achievements_with_expirations

    Achievement.where(id: new_achievement_ids)
  end
end

