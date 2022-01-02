module ChallengeTypes
  class MedalTracker < Challenge
    class MedalCounter
      include StoreModel::Model
      attribute :client_medal_id, :string
      attribute :goal, :integer
      attribute :count, :integer, default: 0
    end

    attribute :dataset, MedalCounter.to_type

    def update_if_applicable!(params)
      return unless params[:achievement]

      if dataset.client_medal_id == params[:achievement].medal.client_medal_id
        with_lock do
          dataset.count += 1

          self.accomplished = true

          save!
        end
      end
    end
  end
end
