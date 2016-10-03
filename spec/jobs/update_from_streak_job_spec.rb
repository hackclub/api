require 'rails_helper'

RSpec.describe UpdateFromStreakJob, type: :job do
  before do
    clubs_key = Rails.application.secrets.streak_club_pipeline_key
    leaders_key = Rails.application.secrets.streak_leader_pipeline_key

    stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{clubs_key}")
      .to_return(status: 200, body: club_pipeline.to_json)
    stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{leaders_key}")
      .to_return(status: 200, body: leader_pipeline.to_json)
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
    let(:api_leaders) { Leader.all.each { |l| leader_to_box(l) } }

    before do
      c_key = Rails.application.secrets.streak_club_pipeline_key
      l_key = Rails.application.secrets.streak_leader_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{c_key}/boxes")
        .to_return(status: 200, body: api_clubs.to_json)
      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{l_key}/boxes")
        .to_return(status: 200, body: api_leaders.to_json)
    end

    it "updates club names" do
      expect {
        UpdateFromStreakJob.perform_now
      }.to change{clubs.last.reload.name}.to("NEW NAME")
    end
  end

  context "with leaders that need to be updated" do
    let(:leaders) { 5.times.map { |l| create(:leader) } }
    let(:api_clubs) { Club.all.each { |c| club_to_box(c) } }
    let(:api_leaders) do
      api_leaders = leaders.map { |l| leader_to_box(l) }
      api_leaders.last[:name] = "NEW NAME"
      api_leaders
    end

    before do
      c_key = Rails.application.secrets.streak_club_pipeline_key
      l_key = Rails.application.secrets.streak_leader_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{c_key}/boxes")
        .to_return(status: 200, body: api_clubs.to_json)
      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{l_key}/boxes")
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
    let(:api_leaders) { Leader.all.map { |l| leader_to_box(l) } }

    before do
      c_key = Rails.application.secrets.streak_club_pipeline_key
      l_key = Rails.application.secrets.streak_leader_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{c_key}/boxes")
        .to_return(status: 200, body: api_clubs.to_json)
      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{l_key}/boxes")
        .to_return(status: 200, body: api_leaders.to_json)
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
    let(:api_clubs) { Club.all.map { |c| club_to_box(c) } }

    before do
      l_key = Rails.application.secrets.streak_leader_pipeline_key
      c_key = Rails.application.secrets.streak_club_pipeline_key

      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{l_key}/boxes")
        .to_return(status: 200, body: api_leaders.to_json)
      stub_request(:get, "https://www.streak.com/api/v1/pipelines/#{c_key}/boxes")
        .to_return(status: 200, body: api_clubs.to_json)
    end

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

  def club_pipeline
    {
      "name": "Club Management",
      "fields": [
        {
          "name": "Source",
          "key": "1004",
          "type": "DROPDOWN",
          "lastUpdatedTimestamp": 1471039454700,
          "dropdownSettings": {
            "items": [
              {
                "key": "9001",
                "name": "Word of Mouth"
              },
              {
                "key": "9002",
                "name": "Unknown"
              },
              {
                "key": "9003",
                "name": "Free Code Camp"
              },
              {
                "key": "9004",
                "name": "GitHub"
              },
              {
                "key": "9005",
                "name": "Press"
              },
              {
                "key": "9006",
                "name": "Searching online"
              },
              {
                "key": "9007",
                "name": "Hackathon"
              },
              {
                "key": "9008",
                "name": "Website"
              },
              {
                "key": "9009",
                "name": "Social media"
              },
              {
                "key": "9010",
                "name": "Hack Camp"
              }
            ]
          }
        },
        {
          "name": "Address",
          "key": "1006",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1472674313991
        },
        {
          "name": "!Latitude",
          "key": "1007",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1474047362658
        },
        {
          "name": "!Longitude",
          "key": "1008",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1474047368438
        }
      ],
      "key": "agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiINemFjaGxhdHRhLmNvbQwLEghXb3JrZmxvdxiAgICA6P2XCgw",
    }
  end

  def leader_pipeline
    {
      "name": "Club Leaders",
      "fields": [
        {
          "name": "Gender",
          "key": "1001",
          "type": "DROPDOWN",
          "lastUpdatedTimestamp": 1470817716205,
          "dropdownSettings": {
            "items": [
              {
                "key": "9001",
                "name": "Male"
              },
              {
                "key": "9002",
                "name": "Female"
              },
              {
                "key": "9003",
                "name": "Other"
              }
            ]
          }
        },
        {
          "name": "Year",
          "key": "1002",
          "type": "DROPDOWN",
          "lastUpdatedTimestamp": 1473210161699,
          "dropdownSettings": {
            "items": [
              {
                "key": "9009",
                "name": "2022"
              },
              {
                "key": "9006",
                "name": "2021"
              },
              {
                "key": "9001",
                "name": "2020"
              },
              {
                "key": "9002",
                "name": "2019"
              },
              {
                "key": "9003",
                "name": "2018"
              },
              {
                "key": "9004",
                "name": "2017"
              },
              {
                "key": "9010",
                "name": "2016"
              },
              {
                "key": "9005",
                "name": "Graduated"
              },
              {
                "key": "9008",
                "name": "Teacher"
              },
              {
                "key": "9007",
                "name": "Unknown"
              }
            ]
          }
        },
        {
          "name": "Email",
          "key": "1003",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1470817806500
        },
        {
          "name": "Slack",
          "key": "1006",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1470819082058
        },
        {
          "name": "Twitter",
          "key": "1008",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1470819096472
        },
        {
          "name": "GitHub",
          "key": "1009",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1470819090390
        },
        {
          "name": "Phone",
          "key": "1010",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1470819103548
        },
        {
          "name": "Address",
          "key": "1011",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1470817900028
        },
        {
          "name": "Do Howdy check-in?",
          "key": "1016",
          "type": "DROPDOWN",
          "lastUpdatedTimestamp": 1472680933687,
          "dropdownSettings": {
            "items": [
              {
                "key": "9001",
                "name": "TRUE"
              }
            ]
          }
        },
        {
          "name": "!Latitude",
          "key": "1018",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1474047977511
        },
        {
          "name": "!Longitude",
          "key": "1019",
          "type": "TEXT_INPUT",
          "lastUpdatedTimestamp": 1474047987572
        }
      ],
      "key": "agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiINemFjaGxhdHRhLmNvbQwLEghXb3JrZmxvdxiAgICAqoeSCgw",
    }
  end
end
