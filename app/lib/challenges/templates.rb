module Challenges
  module Templates
    TEMPLATES = [
      ChallengeTypes::MedalTracker.new(
        title: 'Earn 3 Killionaires in Halo 3',
        xp: 250,
        dataset: {
          client_medal_id: 'Killionaire',
          goal: 3
        }
      ),
      ChallengeTypes::MedalTracker.new(
        title: 'Earn 3 Killionaires in Halo Infinite',
        xp: 250,
        dataset: {
          client_medal_id: 'halo_infinite_killionaire',
          goal: 3
        }
      ),
      ChallengeTypes::MedalTracker.new(
        title: 'Earn a Perfection in Halo 3',
        xp: 500,
        dataset: {
          client_medal_id: 'Perfection',
          goal: 1
        }
      )
    ]

    def self.by_title
      @templates_by_title ||= TEMPLATES.index_by(&:title)
    end
  end
end
