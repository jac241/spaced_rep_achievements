class Achievement < ApplicationRecord
  belongs_to :sync
  belongs_to :medal
  belongs_to :user

  scope :leaders_for, -> (family:, since:) do
    Achievement.select(
      %{
        family_name,
        user_id,
        total_score,
        rank() OVER (PARTITION BY family_name ORDER BY total_score DESC) as family_rank
      }
    ).from(
      Achievement.select(
        %{
          achievements.user_id as user_id,
          families.name as family_name,
          SUM(medals.score) as total_score
         }
      ).joins(medal: :family)
        .where("achievements.client_earned_at > ?", since)
        .group("user_id, family_name")
        .where("families.id = ?", family.id)
    ).order("total_score DESC")
     .includes(:user)
  end
end
