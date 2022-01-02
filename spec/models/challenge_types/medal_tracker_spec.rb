require "rails_helper"
describe ChallengeTypes::MedalTracker do
  describe "#update_if_applicable!" do
    let(:medal) { create(:medal) }
    let(:achievement) { build(:achievement, medal: medal) }

    context "relevant medal earned" do
      subject do
        create(
          :medal_tracker_challenge,
          dataset: described_class::MedalCounter.new(
            client_medal_id: (medal.client_medal_id)
          )
        )
      end

      it "should update the medal count" do
        subject.update_if_applicable!(achievement:)
        subject.reload

        expect(subject.dataset.count).to eq 1
      end

      context "goal count reached" do
        it "should mark the challenge as accomplished" do
          subject.update_if_applicable!(achievement:)
          subject.reload

          expect(subject.accomplished).to be true
        end
      end
    end
    context "irrelevant medal earned" do
      let(:medal_2) { create(:medal, client_medal_id: "not" + medal.client_medal_id) }

      subject do
        create(
          :medal_tracker_challenge,
          dataset: described_class::MedalCounter.new(
            client_medal_id: (medal_2.client_medal_id)
          )
        )
      end

      it "should not increase the count" do
        subject.update_if_applicable!(achievement:)
        subject.reload

        expect(subject.dataset.count).to eq 0
      end
    end
  end
end
