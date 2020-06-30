class Rivalry
  include ActiveModel::Model
  attr_accessor :user, :leaderboard

  def user_ranked?
    user_index.present?
  end

  def user_score
    user_entry.total_score
  end

  def user_rank
    user_entry.family_rank
  end

  def rival
    rival_entry.try(:user)
  end

  def rival_score
    rival_entry.total_score
  end

  def top_3_medals_for_user
    leaderboard.entries[user_index].top_medals_for_user.first(3)
  end

  private

  def user_entry
    @user_entry ||= leaderboard.leaders[user_index]
  end

  def user_index
    @user_index ||= leaderboard.leaders.find_index { |entry| entry.user == user }
  end

  def rival_entry
    if user_index && user_index > 0
      leaderboard.leaders[user_index - 1]
    elsif user_not_ranked_yet?
      leaderboard.leaders[-1]
    end
  end

  def user_not_ranked_yet?
    user_index.nil? && leaderboard.leaders.present?
  end
end
