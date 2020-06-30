class Achievement < ApplicationRecord
  belongs_to :sync, optional: true
  belongs_to :medal
  belongs_to :user

  scope :leaders_for, -> (family:, since:) do
    Achievement.select(
      %{
        family_name,
        user_id,
        total_score,
        achievements_count,
        rank() OVER (PARTITION BY family_name ORDER BY total_score DESC) as family_rank
      }
    ).from(
      Achievement.select(
        %{
          achievements.user_id as user_id,
          families.name as family_name,
          SUM(medals.score) as total_score,
          COUNT(*) as achievements_count
         }
      ).joins(medal: :family)
        .where("achievements.client_earned_at > ?", since)
        .group("user_id, family_name")
        .where("families.id = ?", family.id)
    ).order("total_score DESC")
     .includes(:user)
  end

  scope :top_medals_for, -> (family:, since:) do
    Achievement.select("*").from(
      Achievement.select(
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
        Achievement.select(
          %{
            achievements.user_id as user_id,
            SUM(medals.score) as total_score,
            COUNT(*) as achievements_count,
            SUM(medals.score) as medal_score,
            medals.id as medal_id
           }
        ).joins(medal: :family)
          .where("achievements.client_earned_at > ?", since)
          .group("user_id, medals.id")
          .where("families.id = ?", family.id)
      ).order("total_score DESC")
    ).includes(medal: { image_attachment: :blob }).where("medal_rank <= 5")
#select * from (
	#select 
		#t.user_id,
		#t.medal_name,
		#t.medal_id,
		#RANK() OVER (PARTITION BY t.user_id, t.family_name
					 #ORDER BY t.medal_score DESC) AS medal_rank
	#from (
		#SELECT
			#achievements.user_id as user_id,
			#families.name as family_name,
			#medals.name as medal_name,
			#COUNT(medals.*) as medals_count,
			#SUM(medals.score) as medal_score,
			#medals.id as medal_id
		#FROM achievements
			#JOIN medals ON (achievements.medal_id = medals.id)
			#JOIN families ON (medals.family_id = families.id)
		#WHERE achievements.client_earned_at > ('now'::timestamp - '1 month'::interval)
		#GROUP BY user_id, family_name, medal_name, medals.id 
	#) AS t
#) as top_medals
#WHERE top_medals.medal_rank <= 5
  end
end
