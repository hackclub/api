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

  before(:each) do
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
    let(:club_boxes_resp) do
      club_boxes_resp = clubs.map { |c| club_to_box(c) }
      club_boxes_resp.last[:name] = "NEW NAME"
      club_boxes_resp
    end

    it "updates club names" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{clubs.last.reload.name}.to("NEW NAME")
    end
  end

  context "with leaders that need to be updated" do
    let(:leader_boxes_resp) do
      leader_boxes_resp = leaders.map { |l| leader_to_box(l) }
      leader_boxes_resp.last[:name] = "NEW NAME"
      leader_boxes_resp
    end

    it "updates leader names" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.name}.to("NEW NAME")
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
    let(:club) { create(:club_with_leaders, leader_count: 3) }

    let(:club_boxes_resp) do
      box = club_to_box(club)
      box[:linked_box_keys].pop # Remove last leader from relationship

      [ box ]
    end

    let(:leader_boxes_resp) do
      boxes = club.leaders.map { |l| leader_to_box(l) }
      boxes.last[:linked_box_keys].pop # Remove club from last leader

      boxes
    end

    it "deletes the last club <> leader relationship" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{club.leaders.count}.to(2)
    end
  end

  def club_to_box(club)
    {
      key: club.streak_key,
      name: club.name,
      linked_box_keys: club.leaders.map { |l| l.streak_key },
      fields: {
        "1007" => club.latitude,
        "1008" => club.longitude,
        "1006" => club.address
      }
    }
  end

  def leader_to_box(leader)
    gender_mapping = {
      "Male" => "9001",
      "Female" => "9002",
      "Other" => "9003"
    }

    year_mapping = {
      "2022" => "9009",
      "2021" => "9006",
      "2020" => "9001",
      "2019" => "9002",
      "2018" => "9003",
      "2017" => "9004",
      "2016" => "9010",
      "Graduated" => "9005",
      "Teacher" => "9008",
      "Unknown" => "9007"
    }

    {
      key: leader.streak_key,
      name: leader.name,
      linked_box_keys: leader.clubs.map { |c| c.streak_key },
      fields: {
        "1003" => leader.email,
        "1001" => gender_mapping[leader.gender],
        "1002" => year_mapping[leader.year],
        "1010" => leader.phone_number,
        "1006" => leader.slack_username,
        "1009" => leader.github_username,
        "1008" => leader.twitter_username,
        "1011" => leader.address,
        "1018" => leader.latitude,
        "1019" => leader.longitude
      }
    }
  end
end
