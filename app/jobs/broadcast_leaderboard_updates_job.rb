class BroadcastLeaderboardUpdatesJob < ApplicationJob
  queue_as :realtime_leaderboard

  def perform(medal_statistics:)
    medal_statistics.each do |stat|
      RealtimeLeaderboardsChannel.broadcast_to(
        stat.entry.reified_leaderboard,
        {
          type: 'api/receiveJsonApiData',
          payload: MedalStatisticSerializer.new(
            [stat],
            include: [:entry, :'entry.user', :'entry.user.memberships', :medal],
            fields: {
              user: [:username, :updated_at],
              medal: [:name, :score, :image_path],
              entry: [:score, :updated_at, :online, :user, :reified_leaderboard]
            }
          ).to_hash
        }
      )
    end
  end
end
