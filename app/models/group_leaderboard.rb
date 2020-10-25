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
    @entries ||= leaders.map do |entry_for_user|
      Leaderboard::Entry.new(
        entry_for_user: entry_for_user,
        top_medals_for_user: top_medals_by_user_id[entry_for_user.user_id],
      )
    end
  end

  delegate :timeframe, :family, :top_medals_by_user_id, to: :leaderboard

  private

  def group_member_ids
    @group_member_ids ||= group.members.pluck(:id).to_set
  end
end
