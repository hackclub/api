require "rails_helper"

RSpec.describe Cloud9Client, vcr: true do
  let(:team) { 'hackclub' }

  context "without access token" do
    before { Cloud9Client.access_token = nil }
    after { Cloud9Client.access_token = Rails.application.secrets.cloud9_acess_token }

    it "throws an AuthenticationError" do
      expect {
        Cloud9Client::Team.members(team)
      }.to raise_error(AuthenticationError)
    end
  end
end
