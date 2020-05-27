require "rails_helper"

describe "Creating achievements" do
  describe "POST create" do
    context "with user signed in" do
      let(:headers) { { "ACCEPT" => "application/json" } }
      let(:user) { create(:user) }

      before(:each) do
        sign_in(user)
        headers.merge!(user.create_new_auth_token)
      end

      before(:each) do
        post api_v1_achievements_path, headers: headers, params: {
          achievement: achievement.attributes.merge(medal_attributes)
        }
      end

      let(:medal) { create(:medal) }
      let(:achievement) { build(:achievement) }
      let(:medal_attributes) { { client_medal_id: medal.client_medal_id } }

      context "with good achievement params" do
        it "should return 201" do
          expect(response).to have_http_status(201)
        end

        it "should record an achievement for the user" do
          expect(user.achievements.count).to be 1
        end
      end

      context "with bad non-existent client medal id" do
        let(:medal_attributes) { { client_medal_id: "I don't exist..." } }

        it "should return 422" do
          post api_v1_achievements_path, headers: headers, params: {
            achievement: achievement.attributes.merge(medal_attributes)
          }

          expect(response).to have_http_status(422)
        end

        it "should not create an achievement" do
          expect(user.achievements.count).to be 0
        end
      end
    end
  end
end
