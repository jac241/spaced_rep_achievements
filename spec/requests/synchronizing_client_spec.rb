require "rails_helper"

describe "Synchronizing a client" do
  describe "POST api/v1/syncs" do
    context "with user signed in" do
      let(:headers) { Hash.new }
      let(:user) { create(:user, admin: true) }

      before(:each) do
        sign_in(user)
        headers.merge!(user.create_new_auth_token)
      end

      let(:medal) { create(:medal) }
      let(:achievement) { build(:achievement, user: user) }
      let(:medal_attributes) { { client_medal_id: medal.client_medal_id } }
      let!(:reified_leaderboard) { create(:reified_leaderboard, family: medal.family) }
      let(:achievement_attributes) do
        attrs = achievement.attributes.merge(medal_attributes)
        [
          {
            "id_" => attrs["client_db_id"],
            "medal_id" => attrs["client_medal_id"],
            "deck_id" => attrs["client_deck_id"],
            "created_at" => attrs["client_earned_at"],
            "uuid" => attrs["client_db_uuid"],
          }
        ]
      end

      let(:achievements_file) do
        temp = Tempfile.open('achievements_file', binmode: true)
        IO.binwrite(temp, Zlib::Deflate.deflate(achievement_attributes.to_json))
        fixture_file_upload(temp.path, 'application/zlib', true)
      end

      def post!
        post api_v1_syncs_path, headers: headers, params: {
          client_uuid: achievement.client_uuid,
          achievements_file: achievements_file
        }
        perform_enqueued_jobs
      end

      it "should create an achievement" do
        expect {
          post!
        }.to change { Achievement.count }.by(1)
      end

      RSpec::Matchers.define :after_achievement_arguments_for do |achievement|
        match do |kwargs|
          kwargs[:achievement].client_db_uuid == achievement.client_db_uuid &&
            kwargs[:user] == achievement.user
        end
      end

      it "should perform actions required after achievement created" do
        expect(AfterAchievementCreatedService).to(
          receive(:call).with(after_achievement_arguments_for(achievement)))
          .and_call_original

        post!
      end

      context "older version of anki killstreaks that has no uuid field" do
        before(:each) { achievement_attributes.map { |aa| aa.except!("uuid") } }

        it "should still create an achievement" do
          expect {
            post!
          }.to change { Achievement.count }.by(1)
        end
      end

      context "achievement already exists" do
        let!(:achievement) { create(:achievement) }

        it "should add the new sync id to the achievement", :perform_enqueued do
          post!

          expect(achievement.reload.sync_id).to_not be nil
        end

        it "shouldn't call after achievement created service" do
          expect(AfterAchievementCreatedService).to_not receive(:call)
        end
      end
    end
  end
end
