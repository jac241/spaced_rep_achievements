class GroupLeaderboard
  attr_reader :leaderboard, :group

  def initialize(leaderboard, group)
    @leaderboard = leaderboard
    @group = group
  end

  def leaders
    @leaders ||= leaderboard.leaders.select { |l| group_member_ids.include?(l.user_id) }
  end

  def entries
    @entries ||= leaders.map { |l| make_entry(l) }
  end

  delegate :timeframe, :family, :top_medals_by_user_id, :online_user_ids,
    :make_entry, to: :leaderboard

  private

  def group_member_ids
    @group_member_ids ||= group.members.pluck(:id).to_set
  end
end
