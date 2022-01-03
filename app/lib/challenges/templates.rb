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
      ),
      ChallengeTypes::MedalTracker.new(
        title: 'Earn 5 Tactical Nukes in Call of Duty: Modern Warfare 2',
        xp: 500,
        dataset: {
          client_medal_id: 'mw2_tactical_nuke',
          goal: 5
        }
      )
    ]

    def self.by_title
      @templates_by_title ||= TEMPLATES.index_by(&:title)
    end
  end
end
