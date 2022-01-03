module ChallengeTypes
  class MedalTracker < Challenge
    class MedalCounter
      include StoreModel::Model
      attribute :client_medal_id, :string
      attribute :goal, :integer
      attribute :count, :integer, default: 0

      def at_goal?
        count >= goal
      end
    end

    attribute :dataset, MedalCounter.to_type

    def update_if_applicable!(params)
      return unless params[:achievement]

      if dataset.client_medal_id == params[:achievement].medal.client_medal_id
        with_lock do
          dataset.count += 1

          mark_accomplished_if_completed!

          save!
        end
      end
    end

    def mark_accomplished_if_completed!
      if dataset.at_goal?
        self.accomplished = true
        self.active = false
        battle_pass.on_challenge_completed!(self)
      end
    end

    def progress_percent
      ((dataset.count.to_f / dataset.goal) * 100).round
    end
  end
end
