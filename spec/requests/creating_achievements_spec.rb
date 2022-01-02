require 'rails_helper'

describe 'Creating achievements' do
  describe 'POST create' do
    context 'with user signed in' do
      let(:headers) { { 'ACCEPT' => 'application/json' } }
      let(:user) { create(:user, admin: true) }

      before(:each) do
        sign_in(user)
        headers.merge!(user.create_new_auth_token)
      end

      let(:medal) { create(:medal) }
      let(:achievement) { build(:achievement) }
      let(:medal_attributes) { { client_medal_id: medal.client_medal_id } }
      let!(:leaderboard) { create(:reified_leaderboard, family: medal.family) }

      def post!
        post api_v1_achievements_path, headers: headers, params: {
          achievement: achievement.attributes.merge(medal_attributes)
        }
      end

      context 'with good achievement params' do
        it 'should return 201' do
          post!
          expect(response).to have_http_status(201)
        end

        it 'should record an achievement for the user' do
          post!
          expect(user.achievements.count).to be 1
        end

        it "should update that user's leaderboard entries" do
          post!
          entry = user.entries.where(reified_leaderboard: leaderboard).first
          expect(entry.score).to eq medal.score
        end

        it "should update that user's medal statistic" do
          post!
          medal_statistic = user.medal_statistics.where(entries: { reified_leaderboard: leaderboard }).first
          expect(medal_statistic.count).to eq 1
          expect(medal_statistic.score).to eq medal.score
        end

        context 'with medal tracking challenges' do
          let!(:medal_tracker_challenge) do
            create(
              :medal_tracker_challenge,
              battle_pass: user.battle_passes.last,
              dataset: ChallengeTypes::MedalTracker::MedalCounter.new(
                client_medal_id: medal.client_medal_id
              )
            )
          end
          it 'should update any relevant challenges' do
            post!
            perform_enqueued_jobs
            medal_tracker_challenge.reload

            expect(medal_tracker_challenge.dataset.count).to eq 1
          end
        end

        context 'multiple leaderboards' do
          before :each do
            create(
              :reified_leaderboard,
              family: medal.family,
              timeframe: ReifiedLeaderboard.timeframes.keys.last
            )
          end

          it 'should create achievement expirations for each ' do
            post!
            expect(user.achievements.first.expirations.count).to eq ReifiedLeaderboard.count
          end
        end
      end

      context 'with bad non-existent client medal id' do
        let(:medal_attributes) { { client_medal_id: "I don't exist..." } }

        it 'should return 422' do
          post!
          expect(response).to have_http_status(422)
        end

        it 'should not create an achievement' do
          post!
          expect(user.achievements.count).to be 0
        end
      end
    end
  end
end
