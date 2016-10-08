require "rails_helper"

RSpec.describe "V1::Leaders", type: :request do
  describe "POST /v1/leaders/intake" do
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
        address: "4242 Fake St, Some City, CA 90210"
      }
    }

    context "with valid attributes" do
      before { post "/v1/leaders/intake", params: req_body }

      it "creates the leader" do
        expect(response.status).to eq(201)

        # Check to make sure every attribute we provided is set
        req_body.each do |k, v|
          expect(json[k.to_s]).to eq(v)
        end
      end

      it "geocodes the address" do
        # These are really decimals, but encoded are as strings in JSON to
        # preserve accuracy.
        expect(json["latitude"]).to be_a String
        expect(json["longitude"]).to be_a String
      end
    end

    it "doesn't create the leader with invalid attributes" do
      post "/v1/leaders/intake", params: req_body.except(:name)

      expect(response.status).to eq(422)
      expect(json["errors"]["name"]).to eq(["can't be blank"])
    end
  end
end
