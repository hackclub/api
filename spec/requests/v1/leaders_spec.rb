require "rails_helper"

RSpec.describe "V1::Leaders", type: :request, focus: true do
  describe "POST /v1/leaders/intake" do
    let(:club) { create(:club) }
    let(:req_body) {
      {
        name: "Foo Bar",
        email: "foo@bar.com",
        gender: "Other",
        year: "2016",
        phone_number: "444-444-4444",
        slack_username: "foo_bar",
        github_username: "foo_bar",
        twitter_username: "foobar",
        address: "4242 Fake St, Some City, CA 90210",
        club_id: club.id
      }
    }

    context "with valid attributes" do
      before { post "/v1/leaders/intake", params: req_body }

      it "creates the leader" do
        expect(response.status).to eq(201)

        # Check to make sure expected attributes are set
        #
        # We don't check for club_id because leaders can have multiple clubs and
        # the intake form doesn't support creating a leader with multiple clubs.
        req_body.except(:club_id).each do |k, v|
          expect(json[k.to_s]).to eq(v)
        end
      end

      it "geocodes the address" do
        # These are really decimals, but encoded are as strings in JSON to
        # preserve accuracy.
        expect(json["latitude"]).to be_a String
        expect(json["longitude"]).to be_a String
      end

      it "adds the leader to the given club" do
        expect(json["clubs"]).to eq([
          # Gotta do this to get the parsed JSON representation of the club
          JSON.parse(club.to_json)
        ])
      end
    end

    it "doesn't create the leader with invalid attributes" do
      post "/v1/leaders/intake", params: req_body.except(:name)

      expect(response.status).to eq(422)
      expect(json["errors"]["name"]).to eq(["can't be blank"])
    end

    it "doesn't create the leader with a club id that doesn't exist" do
      req_body[:club_id] = -1
      post "/v1/leaders/intake", params: req_body

      expect(response.status).to eq(422)
      expect(json["errors"]["club_id"]).to eq(["doesn't exist"])
    end
  end
end
