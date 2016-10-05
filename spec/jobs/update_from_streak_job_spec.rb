require 'rails_helper'

RSpec.describe UpdateFromStreakJob, type: :job do
  let(:clubs) { 5.times.map { create(:club_with_leaders) } }
  let(:leaders) { Leader.all }

  let(:club_boxes_resp) { clubs.map { |c| club_to_box(c) } }
  let(:leader_boxes_resp) { leaders.map { |l| leader_to_box(l) } }

  let(:club_pipeline_resp) do
    JSON.parse(
      File.read(
        File.expand_path("support/club_pipeline_resp.json", __dir__)
      )
    )
  end

  let(:leader_pipeline_resp) do
    JSON.parse(
      File.read(
        File.expand_path("support/leader_pipeline_resp.json", __dir__)
      )
    )
  end

  def stub_streak_reqs!
    clubs_key = Rails.application.secrets.streak_club_pipeline_key
    leaders_key = Rails.application.secrets.streak_leader_pipeline_key

    stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{clubs_key}")
      .to_return(status: 200, body: club_pipeline_resp.to_json)
    stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{leaders_key}")
      .to_return(status: 200, body: leader_pipeline_resp.to_json)

    stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{clubs_key}/boxes")
      .to_return(status: 200, body: club_boxes_resp.to_json)
    stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{leaders_key}/boxes")
      .to_return(status: 200, body: leader_boxes_resp.to_json)
  end

  before(:each) { stub_streak_reqs! }

  context "with no clubs or clubs leaders saved locally" do
    let(:clubs) { 5.times.map { build(:club) } }
    let(:leaders) do
      clubs.map do |club|
        leader = build(:leader)
        leader.clubs << club
        leader
      end
    end

    it "creates clubs" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{Club.count}
    end

    it "creates leaders" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{Leader.count}
    end

    it "creates relationships between clubs and leaders" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change {
        has_created_relationship = false

        Leader.find_each { |l| has_created_relationship = true if l.clubs.count > 0 }

        has_created_relationship
      }.from(false).to(true)
    end
  end

  context "with clubs that need to be updated" do
    before do
      field_maps = Club::STREAK_FIELD_MAPPINGS

      clubs.last.update_attributes!(source: "Word of Mouth")

      club_boxes_resp.last[:name] = "NEW NAME"
      club_boxes_resp.last[:fields][field_maps[:address]] = "NEW ADDRESS"
      club_boxes_resp.last[:fields][field_maps[:latitude]] = 13.37
      club_boxes_resp.last[:fields][field_maps[:longitude]] = -13.37
      club_boxes_resp.last[:fields][field_maps[:source][:key]] =
        field_maps[:source][:options]["Press"]
      club_boxes_resp.last[:notes] = "NEW NOTES"

      stub_streak_reqs!
    end

    it "updates club names" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{clubs.last.reload.name}.to("NEW NAME")
    end

    it "updates club addresses" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{clubs.last.reload.address}.to("NEW ADDRESS")
    end

    it "doesn't update club latitudes" do
      UpdateFromStreakJob.perform_now
      expect(clubs.last.reload.latitude).to_not eq(13.37)
    end

    it "doesn't update club longitudes" do
      UpdateFromStreakJob.perform_now
      expect(clubs.last.reload.longitude).to_not eq(-13.37)
    end

    it "updates club source" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{clubs.last.reload.source}.to("Press")
    end

    it "updates club notes" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{clubs.last.reload.notes}.to("NEW NOTES")
    end
  end

  context "with leaders that need to be updated" do
    before do
      field_maps = Leader::STREAK_FIELD_MAPPINGS

      leaders.last.update_attributes!(gender: "Male", year: "Unknown")

      leader_boxes_resp.last[:name] = "NEW NAME"
      leader_boxes_resp.last[:fields][field_maps[:email]] = "new@email.com"
      leader_boxes_resp.last[:fields][field_maps[:gender][:key]] =
        field_maps[:gender][:options]["Female"]
      leader_boxes_resp.last[:fields][field_maps[:year][:key]] =
        field_maps[:year][:options]["2016"]
      leader_boxes_resp.last[:fields][field_maps[:phone_number]] = "424-242-4242"
      leader_boxes_resp.last[:fields][field_maps[:slack_username]] = "new_slack_username"
      leader_boxes_resp.last[:fields][field_maps[:github_username]] = "new_github_username"
      leader_boxes_resp.last[:fields][field_maps[:twitter_username]] = "new_twitter_username"
      leader_boxes_resp.last[:fields][field_maps[:address]] = "NEW ADDRESS"
      leader_boxes_resp.last[:fields][field_maps[:latitude]] = 13.37
      leader_boxes_resp.last[:fields][field_maps[:longitude]] = -13.37
      leader_boxes_resp.last[:notes] = "NEW NOTES"
      stub_streak_reqs!
    end

    it "updates leader names" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.name}.to("NEW NAME")
    end

    it "updates leader email" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.email}.to("new@email.com")
    end

    it "updates leader gender" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.gender}.to("Female")
    end

    it "updates leader year" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.year}.to("2016")
    end

    it "updates leader phone number" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.phone_number}.to("424-242-4242")
    end

    it "updates Slack username" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.slack_username}.to("new_slack_username")
    end

    it "updates GitHub username" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.github_username}.to("new_github_username")
    end

    it "updates Twitter username" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.twitter_username}.to("new_twitter_username")
    end

    it "updates address" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.address}.to("NEW ADDRESS")
    end

    it "doesn't update latitude" do
      UpdateFromStreakJob.perform_now
      expect(leaders.last.reload.latitude).to_not eq(13.37)
    end

    it "doesn't update longitude" do
      UpdateFromStreakJob.perform_now
      expect(leaders.last.reload.longitude).to_not eq(-13.37)
    end

    it "updates leader notes" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.notes}.to("NEW NOTES")
    end
  end

  context "with clubs that need to be deleted" do
    # Every club except for the last one
    let(:club_boxes_resp) { clubs[0..-2].map { |c| club_to_box(c) } }

    it "deletes the last club" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{Club.exists? clubs.last.id}.to(false)
    end
  end

  context "with leaders that need to be deleted" do
    # Every leader except for the last one
    let(:leader_boxes_resp) { leaders[0..-2].map { |l| leader_to_box(l) } }

    it "deletes the last leader" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{Leader.exists? leaders.last.id}.to(false)
    end
  end

  context "with club <> leader relationships that need to be deleted" do
    let(:clubs) { [ create(:club_with_leaders, leader_count: 3) ] }

    before do
      # Remove last leader from club
      club_boxes_resp.last[:linked_box_keys].pop

      # And remove the club from the last leader
      leader_boxes_resp.last[:linked_box_keys].pop

      stub_streak_reqs!
    end

    it "deletes the last club <> leader relationship" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{clubs.last.leaders.count}.to(2)
    end
  end

  def club_to_box(club)
    field_maps = Club::STREAK_FIELD_MAPPINGS

    {
      key: club.streak_key,
      name: club.name,
      linked_box_keys: club.leaders.map { |l| l.streak_key },
      fields: {
        field_maps[:address] => club.address,
        field_maps[:latitude] => club.latitude,
        field_maps[:longitude] => club.longitude,
        field_maps[:source][:key] => field_maps[:source][:options][club.source]
      }
    }
  end

  def leader_to_box(leader)
    field_maps = Leader::STREAK_FIELD_MAPPINGS

    {
      key: leader.streak_key,
      name: leader.name,
      linked_box_keys: leader.clubs.map { |c| c.streak_key },
      fields: {
        field_maps[:email] => leader.email,
        field_maps[:gender][:key] => field_maps[:gender][:options][leader.gender],
        field_maps[:year][:key] => field_maps[:year][:options][leader.year],
        field_maps[:phone_number] => leader.phone_number,
        field_maps[:slack_username] => leader.slack_username,
        field_maps[:github_username] => leader.github_username,
        field_maps[:twitter_username] => leader.twitter_username,
        field_maps[:address] => leader.address,
        field_maps[:latitude] => leader.latitude,
        field_maps[:longitude] => leader.longitude
      }
    }
  end
end
