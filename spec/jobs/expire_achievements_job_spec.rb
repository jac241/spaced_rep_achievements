require "rails_helper"

describe ExpireAchievementsJob do
  let!(:leaderboard) { create(:reified_leaderboard, timeframe: "monthly") }
  let(:user) { create(:user) }
  let!(:achievements) { create_list(:achievement, 2, user: user) }

  let!(:expiration) do
    create(
      :expiration,
      reified_leaderboard: leaderboard,
      created_at: 35.days.ago,
      achievement: achievements.first,
    )
  end
  let!(:indate_expiration) do
    create(
      :expiration,
      reified_leaderboard: leaderboard,
      created_at: 25.days.ago,
      achievement: achievements.second,
    )
  end

  let!(:entry) do
    create(
      :entry,
      score: Achievement.all.sum { |a| a.medal.score },
      user: expiration.achievement.user,
      reified_leaderboard: leaderboard
    )
  end

  describe "#perform" do
    it "should remove achievement's points from reified leaderboards" do
      subject.perform

      expect(entry.reload.score).to eq indate_expiration.points
    end

    it "should destroy the expiration" do
      subject.perform

      expect(Expiration.count).to eq 1
    end
  end
end
