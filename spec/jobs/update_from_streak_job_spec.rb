require 'rails_helper'

RSpec.describe UpdateFromStreakJob, type: :job do
  around do |example|
    ClimateControl.modify STREAK_CLUB_PIPELINE_KEY: "clubs",
                          STREAK_LEADER_PIPELINE_KEY: "leaders" do
      example.run
    end
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

    let(:api_clubs) { clubs.map { |c| club_to_box(c) } }
    let(:api_leaders) { leaders.map { |l| leader_to_box(l) } }

    before do
      c_key = Rails.application.secrets.streak_club_pipeline_key
      l_key = Rails.application.secrets.streak_leader_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{c_key}/boxes")
        .to_return(status: 200, body: api_clubs.to_json)
      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{l_key}/boxes")
        .to_return(status: 200, body: api_leaders.to_json)
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
    let(:clubs) { 5.times.map { create(:club) } }
    let(:api_clubs) do
      api_clubs = clubs.map { |c| club_to_box(c) }
      api_clubs.last[:name] = "NEW NAME"
      api_clubs
    end

    before do
      p_key = Rails.application.secrets.streak_club_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{p_key}/boxes")
        .to_return(status: 200, body: api_clubs.to_json)
    end

    it "updates club names" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{clubs.last.reload.name}.to("NEW NAME")
    end
  end

  context "with leaders that need to be updated" do
    let(:leaders) { 5.times.map { |l| create(:leader) } }
    let(:api_leaders) do
      api_leaders = leaders.map { |l| leader_to_box(l) }
      api_leaders.last[:name] = "NEW NAME"
      api_leaders
    end

    before do
      p_key = Rails.application.secrets.streak_leader_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{p_key}/boxes")
        .to_return(status: 200, body: api_leaders.to_json)
    end

    it "updates leader names" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{leaders.last.reload.name}.to("NEW NAME")
    end
  end

  context "with clubs that need to be deleted" do
    let(:clubs) { 5.times.map { |c| create(:club) } }

    # Every club except for the last one
    let(:api_clubs) { clubs[0..-2].map { |c| club_to_box(c) } }

    before do
      p_key = Rails.application.secrets.streak_club_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{p_key}/boxes")
        .to_return(status: 200, body: api_clubs.to_json)
    end

    it "deletes the last club" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{Club.exists? clubs.last.id}.to(false)
    end
  end

  context "with leaders that need to be deleted" do
    let(:leaders) { 5.times.map { |l| create(:leader) } }

    # Every leader except for the last one
    let(:api_leaders) { leaders[0..-2].map { |l| leader_to_box(l) } }

    it "deletes the last leader" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{Leader.exists? leaders.last.id}.to(false)
    end
  end

  context "with club <> leader relationships that need to be deleted" do
    let(:club) { create(:club_with_leaders, leader_count: 3) }

    let(:api_clubs) do
      box = club_to_box(club)
      box[:linked_box_keys].pop # Remove last leader from relationship

      [ box ]
    end

    let(:api_leaders) do
      boxes = club.leaders.map { |l| leader_to_box(l) }
      boxes.last[:linked_box_keys].pop # Remove club from last leader

      boxes
    end

    before do
      c_key = Rails.application.secrets.streak_club_pipeline_key
      l_key = Rails.application.secrets.streak_leader_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{c_key}/boxes")
        .to_return(status: 200, body: api_clubs.to_json)
      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{l_key}/boxes")
        .to_return(status: 200, body: api_leaders.to_json)
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
