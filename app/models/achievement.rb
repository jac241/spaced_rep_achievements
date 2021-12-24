class Achievement < ApplicationRecord
  belongs_to :sync, optional: true
  belongs_to :medal
  belongs_to :user

  has_many :expirations, dependent: :destroy

  scope :in_order_earned, -> { order(client_earned_at: :asc) }

  scope :leaders_for, lambda { |family:, since:|
    self.select(
      %{
        family_name,
        user_id,
        total_score,
        achievements_count,
        rank() OVER (PARTITION BY family_name ORDER BY total_score DESC) as family_rank
      }
    ).from(
      self.select(
        %{
          achievements.user_id as user_id,
          families.name as family_name,
          SUM(medals.score) as total_score,
          COUNT(*) as achievements_count
         }
      ).joins(medal: :family)
        .where('achievements.client_earned_at > ?', since)
        .group('user_id, family_name')
        .where('families.id = ?', family.id)
    ).order('total_score DESC')
        .includes(:user)
  }

  scope :top_medals_for, lambda { |family:, since:|
    self.select('*').from(
      self.select(
        %{
          user_id,
          total_score,
          achievements_count,
          medal_id,
          rank() OVER (
            PARTITION BY user_id ORDER BY medal_score DESC
          ) as medal_rank
        }
      ).from(
        self.select(
          %{
            achievements.user_id as user_id,
            SUM(medals.score) as total_score,
            COUNT(*) as achievements_count,
            SUM(medals.score) as medal_score,
            medals.id as medal_id
           }
        ).joins(medal: :family)
          .where('achievements.client_earned_at > ?', since)
          .group('user_id, medals.id')
          .where('families.id = ?', family.id)
      ).order('total_score DESC')
    ).includes(medal: { image_attachment: :blob }).where('medal_rank <= 5')
  }

  def family
    medal.family
  end
end
