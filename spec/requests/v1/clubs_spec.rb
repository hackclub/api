require "rails_helper"

RSpec.describe "V1::Clubs", type: :request do
  describe "GET /v1/clubs" do
    it "returns an empty array when no clubs exist" do
      get "/v1/clubs"

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
      expect(json).to eq([])
    end

    context "when multiple clubs exist" do
      before do
        5.times { create(:club) }
      end

      it "returns the correct number of clubs" do
        get "/v1/clubs"

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")
        expect(json.length).to eq(5)
      end
    end
  end

  describe "POST /v1/clubs" do
    let(:location_attrs) { attributes_for(:club).except(:latitude, :longitude) }

    context "with valid attributes" do
      before { post "/v1/clubs", params: location_attrs }

      it "creates the club" do
        expect(response.status).to eq(201)

        # Check to make sure every attribute we provided is set
        location_attrs.except(:streak_key).each do |k, v|
          expect(json[k.to_s]).to eq(v)
        end
      end

      it "geocodes the address" do
        # These are really decimals, but are encoded as strings in JSON to
        # preserve accuracy.
        expect(json["latitude"]).to be_a String
        expect(json["longitude"]).to be_a String
      end
    end

    it "doesn't create a club with invalid attributes" do
      post "/v1/clubs", params: location_attrs.except(:name)

      expect(response.status).to eq(422)
      expect(json["errors"]["name"]).to eq(["can't be blank"])
    end
  end

  describe "GET /v1/clubs/:id" do
    before { get "/v1/clubs/#{id}" }

    let(:club) { create(:club) }

    context "with valid id" do
      let(:id) { club.id }

      # We need to serialize the club to JSON and then parse that JSON to make
      # the attributes match what the API will return since JSON doesn't support
      # floating point numbers to the precision that Rails does.
      let(:club_attrs) do
        JSON.parse(club.to_json).except("latitude", "longitude")
      end

      it "retrieves the club successfully" do
        expect(response).to have_http_status(200)

        # Make sure all attributes match
        club_attrs.each do |k, v|
          expect(json[k]).to eq(v)
        end
      end
    end

    context "with invalid id" do
      let(:id) { club.id + 1 }

      it "receives a 404" do
        expect(response).to have_http_status(404)
        expect(json["error"]).to eq("Club not found")
      end
    end
  end

  describe "PATCH /v1/clubs/:id" do
    before { patch "/v1/clubs/#{id}", params: body }

    let(:club) { create(:club) }
    let(:id) { club.id }

    context "with valid attributes" do
      let(:body) { { name: "Foo bar"} }

      it "successfully updates the club" do
        expect(response).to have_http_status(200)
        expect(json["name"]).to eq("Foo bar")
      end
    end

    context "with invalid attributes" do
      let(:body) { { name: nil } }

      it "fails" do
        expect(response).to have_http_status(422)
        expect(json["errors"]["name"]).to eq(["can't be blank"])
      end
    end

    context "with invalid id" do
      let(:id) { club.id + 1 }

      it "receives a 404" do
        expect(response).to have_http_status(404)
        expect(json["error"]).to eq("Club not found")
      end
    end
  end

  describe "DELETE /v1/clubs/:id" do
    let!(:club) { create(:club) }

    it "deletes successfully with valid id" do
      expect { delete "/v1/clubs/#{club.id}" }.to change { Club.count }.by(-1)

      expect(response).to have_http_status(200)
      expect(json["status"]).to eq("success")
    end

    it "throws a 404 and fails to delete with invalid id" do
      expect { delete "/v1/clubs/#{club.id + 1}" }.to_not change { Club.count }

      expect(response).to have_http_status(404)
      expect(json["error"]).to eq("Club not found")
    end
  end
end
