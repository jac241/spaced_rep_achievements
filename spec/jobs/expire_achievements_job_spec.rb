require "rails_helper"

describe ExpireAchievementsJob do
  let!(:leaderboard) { create(:reified_leaderboard, timeframe: "monthly") }
  let!(:medal) { create(:medal) }
  let(:user) { create(:user) }
  let!(:expired_achievement) { create(:achievement, user: user, medal: medal, client_earned_at: 35.days.ago) }
  let!(:expired_achievement2) { create(:achievement, user: user, medal: medal, client_earned_at: 35.days.ago) }
  let!(:indate_achievement) { create(:achievement, user: user, medal: medal, client_earned_at: 25.days.ago) }

  let!(:expired_expirations) do
    [
      create(
        :expiration,
        reified_leaderboard: leaderboard,
        created_at: 35.days.ago,
        achievement: expired_achievement,
      ),
      create(
        :expiration,
        reified_leaderboard: leaderboard,
        created_at: 35.days.ago,
        achievement: expired_achievement2,
      ),
    ]
  end
  let!(:indate_expiration) do
    create(
      :expiration,
      reified_leaderboard: leaderboard,
      created_at: 25.days.ago,
      achievement: indate_achievement,
    )
  end

  let!(:entry) do
    create(
      :entry,
      score: Achievement.all.sum { |a| a.medal.score },
      user: user,
      reified_leaderboard: leaderboard
    )
  end

  let!(:medal_stats) do
    create(
      :medal_statistic,
      score: Achievement.all.sum { |a| a.medal.score },
      count: Achievement.count,
      entry: entry,
      medal: medal
    )
  end

  describe "#perform" do
    it "should remove achievement's points from reified leaderboards" do
      subject.perform

      expect(entry.reload.score).to eq indate_expiration.points
    end

    it "should remove achievement's medal from medal stats" do
      subject.perform

      medal_stats.reload

      expect(medal_stats.count).to eq 1
      expect(medal_stats.score).to eq medal.score
    end

    it "should destroy the expiration" do
      subject.perform

      expect(Expiration.count).to eq 1
    end
  end
end
