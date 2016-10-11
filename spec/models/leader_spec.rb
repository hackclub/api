require "rails_helper"

RSpec.describe Leader, type: :model do
  subject { build(:leader) }

  it { should have_db_column :name }
  it { should have_db_column :streak_key }
  it { should have_db_column :gender }
  it { should have_db_column :year }
  it { should have_db_column :email }
  it { should have_db_column :slack_username }
  it { should have_db_column :github_username }
  it { should have_db_column :twitter_username }
  it { should have_db_column :phone_number }
  it { should have_db_column :address }
  it { should have_db_column :latitude }
  it { should have_db_column :longitude }
  it { should have_db_column :notes }

  it { should validate_presence_of :name }

  it { should have_and_belong_to_many :clubs }

  context "creation" do
    let(:attrs) { attributes_for(:leader_with_address).except(:streak_key, :latitude, :longitude) }
    subject(:leader) { Leader.create(attrs) }

    it "geocodes the address" do
      expect(leader.latitude).to be_a BigDecimal
      expect(leader.longitude).to be_a BigDecimal
    end

    context "without clubs" do
      it "creates a new box on Streak with all attributes" do
        l = Leader.new(attrs)

        client = class_double(StreakClient::Box).as_stubbed_const
        streak_key = HCFaker::Streak.key
        field_maps = Leader::STREAK_FIELD_MAPPINGS

        # Leader attributes
        expect(client).to receive(:create_in_pipeline)
                            .with(
                              Rails.application.secrets.streak_leader_pipeline_key,
                              attrs[:name]
                            )
                            .and_return({ key: streak_key })
        expect(client).to receive(:update)
                            .with(
                              streak_key,
                              notes: attrs[:notes],
                              linkedBoxKeys: []
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:email],
                              attrs[:email]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:gender][:key],
                              field_maps[:gender][:options][attrs[:gender]]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:year][:key],
                              field_maps[:year][:options][attrs[:year]]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:phone_number],
                              attrs[:phone_number]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:slack_username],
                              attrs[:slack_username]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:github_username],
                              attrs[:github_username]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:twitter_username],
                              attrs[:twitter_username]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:address],
                              attrs[:address]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:latitude],
                              anything
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              streak_key,
                              field_maps[:longitude],
                              anything
                            )

        l.save
      end
    end

    it "sets streak_key" do
      expect(leader.streak_key).to be_a String
    end
  end

  context "updating" do
    let(:attrs) { attributes_for(:leader_with_address)
                    .except(:streak_key, :latitude, :longitude) }
    subject(:leader) { Leader.create(attrs) }

    before do
      leader.update_attributes(gender: "Female", year: "2016")

      leader.email = "new@email.com"
      leader.gender = "Male"
      leader.year = "2017"
      leader.phone_number = "1-444-444-4444"
      leader.slack_username = "new_slack_username"
      leader.github_username = "new_github_username"
      leader.twitter_username = "new_twitter_username"
      leader.address = "NEW ADDRESS"
      leader.notes = "NEW NOTES"
    end

    describe "geocoding" do
      before do
        Geocoder::Lookup::Test.set_default_stub(
          [
            {
              "latitude" => 42.42,
              "longitude" => -42.42
            }
          ]
        )
      end

      after { Geocoder::Lookup::Test.reset }

      it "saves the new latitude" do
        expect { leader.save }.to change{leader.reload.latitude}
      end

      it "saves the new longitude" do
        expect { leader.save }.to change{leader.reload.longitude}
      end
    end

    context "without clubs" do
      it "updates the Streak box's attributes" do
        client = class_double(StreakClient::Box).as_stubbed_const
        field_maps = Leader::STREAK_FIELD_MAPPINGS

        expect(client).to receive(:update)
                           .with(
                             leader.streak_key,
                             notes: "NEW NOTES",
                             linkedBoxKeys: []
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:email],
                             'new@email.com'
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:gender][:key],
                             field_maps[:gender][:options]['Male']
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:year][:key],
                             field_maps[:year][:options]['2017']
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:phone_number],
                             '1-444-444-4444'
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:slack_username],
                             'new_slack_username'
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:github_username],
                             'new_github_username'
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:twitter_username],
                             'new_twitter_username'
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:address],
                             'NEW ADDRESS'
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:latitude],
                             anything
                           )
        expect(client).to receive(:edit_field)
                           .with(
                             leader.streak_key,
                             field_maps[:longitude],
                             anything
                           )

        leader.save
      end
    end
  end
end
