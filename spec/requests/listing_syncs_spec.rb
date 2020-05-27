describe "Listing syncs" do
  describe "GET syncs/index" do
    context "with user signed in" do
      let(:headers) { { "ACCEPT" => "application/json" } }
      let(:user) { create(:user) }

      before(:each) do
        sign_in(user)
        headers.merge!(user.create_new_auth_token)
      end

      before(:each) do
        get api_v1_syncs_path, headers: headers
      end

      context "with no previous syncs" do
        it "should return an empty array" do
          body = JSON.parse(response.body)
          expect(body).to eq []
        end
      end

      context "with previous syncs" do
        before(:each) do
          @syncs = create_list(:sync, 2, user_id: user.id)
        end

        it "should return the syncs" do
          body = JSON.parse(response.body)
          body.each do |sync_attrs|
            expect(sync_attrs[:client_uuid]).to eq @syncs.first.client_uuid
          end
        end
      end
    end
  end
end
