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
      let(:achievement) { build(:achievement) }
      let(:medal_attributes) { { client_medal_id: medal.client_medal_id } }
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
      end

      it "should create an achievement" do
        expect {
          post!
          perform_enqueued_jobs
        }.to change { Achievement.count }.by(1)
      end

      context "older version of anki killstreaks that has no uuid field" do
        before(:each) { achievement_attributes.map { |aa| aa.except!("uuid") } }

        it "should still create an achievement" do
          expect {
            post!
            perform_enqueued_jobs
          }.to change { Achievement.count }.by(1)
        end
      end

      context "achievement already exists" do
        let!(:achievement) { create(:achievement) }

        it "should add the new sync id to the achievement", :perform_enqueued do
          post!
          perform_enqueued_jobs

          expect(achievement.reload.sync_id).to_not be nil
        end
      end
    end
  end
end
