require 'rails_helper'

describe BattlePass do
  describe '#on_challenge_completed' do
    subject { create(:battle_pass) }
    let!(:medal_tracker_challenge) do
      create(:medal_tracker_challenge, battle_pass: subject)
    end

    it 'should increase xp by the amount of the challenge' do
      old_xp = subject.xp
      subject.on_challenge_completed!(medal_tracker_challenge)
      subject.reload
      expect(subject.xp).to eq old_xp + medal_tracker_challenge.xp
    end
  end
end
