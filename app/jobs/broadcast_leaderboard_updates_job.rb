class BroadcastLeaderboardUpdatesJob < ApplicationJob
  queue_as :realtime_leaderboard

  def perform(medal_statistics:)
    #entries.each do |entry|
      #RealtimeLeaderboardsChannel.broadcast_to(
        #entry.reified_leaderboard,
        #{
          #type: "api/receiveJsonApiData",
          #payload: EntrySerializer.new(
            #[ entry ],
            #include: [ :user ],
            #fields: { user: [:username] },
          #).to_hash
        #}
      #)
    #end

    medal_statistics.each do |stat|
      RealtimeLeaderboardsChannel.broadcast_to(
        stat.entry.reified_leaderboard,
        {
          type: "api/receiveJsonApiData",
          payload: MedalStatisticSerializer.new(
            [ stat ],
            include: [ :entry, :"entry.user", :medal ],
            fields: {
              user: [:username],
              medal: [:name, :score, :image_path]
            },
          ).to_hash
        }
      )
    end
  end
end
