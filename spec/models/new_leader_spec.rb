# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewLeader, type: :model do
  subject { build(:new_leader) }

  # for time warping
  include ActiveSupport::Testing::TimeHelpers

  ## db columns ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :name }
  it { should have_db_column :email }
  it { should have_db_column :birthday }
  it { should have_db_column :expected_graduation }
  it { should have_db_column :gender }
  it { should have_db_column :ethnicity }
  it { should have_db_column :phone_number }
  it { should have_db_column :address }
  it { should have_db_column :latitude }
  it { should have_db_column :longitude }
  it { should have_db_column :parsed_address }
  it { should have_db_column :parsed_city }
  it { should have_db_column :parsed_state }
  it { should have_db_column :parsed_state_code }
  it { should have_db_column :parsed_postal_code }
  it { should have_db_column :parsed_country }
  it { should have_db_column :parsed_country_code }
  it { should have_db_column :personal_website }
  it { should have_db_column :github_url }
  it { should have_db_column :linkedin_url }
  it { should have_db_column :facebook_url }
  it { should have_db_column :twitter_url }

  ## types ##

  it { should define_enum_for :gender }
  it { should define_enum_for :ethnicity }

  ## associations ##

  it { should have_many(:leadership_positions) }
  it { should have_many(:new_clubs).through(:leadership_positions) }
  it { should have_one(:user) }

  it { should have_one :leader }

  ## validations ##

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :ethnicity }
  it { should validate_presence_of :phone_number }
  it { should validate_presence_of :address }

  it 'validates urls' do
    expect(subject.valid?).to eq(true)

    subject.personal_website = 'bad'
    subject.github_url = 'bad'
    subject.linkedin_url = 'bad'
    subject.facebook_url = 'bad'
    subject.twitter_url = 'bad'

    expect(subject.valid?).to eq(false)

    expect(subject.errors).to include(
      :personal_website,
      :github_url,
      :linkedin_url,
      :facebook_url,
      :twitter_url
    )
  end

  it_behaves_like 'Geocodeable'

  describe ':from_leader_profile' do
    let(:leader_profile) do
      create(
        :leader_profile,
        leader_name: 'Prophet Orpheus',
        leader_email: 'orpheus@hackclub.com',
        leader_birthday: Date.parse('1997-10-22'),
        leader_year_in_school: :junior,
        leader_gender: :agender,
        leader_ethnicity: :other_ethnicity,
        leader_phone_number: '333-333-3333',
        leader_address: 'The Internet',
        presence_personal_website: 'https://orpheus.com',
        presence_github_url: 'https://github.com/orpheus',
        presence_linkedin_url: 'https://linkedin.com/in/orpheus',
        presence_facebook_url: 'https://facebook.com/orpheus',
        presence_twitter_url: 'https://twitter.com/orpheus'
      )
    end
    let(:profile) { leader_profile } # alias for convenience

    before do
      # set the clock at 2016-01-15 to test calculation of expected_graduation
      travel_to Time.gm(2016, 0o1, 15) do
        @res = subject.from_leader_profile(leader_profile)
      end
    end

    it 'properly sets all leader profile fields' do
      expect(subject.name).to eq('Prophet Orpheus')
      expect(subject.email).to eq('orpheus@hackclub.com')
      expect(subject.birthday).to eq(Date.parse('1997-10-22'))
      expect(subject.expected_graduation).to eq(Time.gm(2017, 6))
      expect(subject.gender.intern).to eq(:agender)
      expect(subject.ethnicity.intern).to eq(:other_ethnicity)
      expect(subject.phone_number).to eq('333-333-3333')

      # location attrs
      expect(subject.address).to eq(leader_profile.leader_address)
      expect(subject.latitude).to eq(leader_profile.leader_latitude)
      expect(subject.longitude).to eq(leader_profile.leader_longitude)
      expect(subject.parsed_address).to eq(
        leader_profile.leader_parsed_address
      )
      expect(subject.parsed_city).to eq(
        leader_profile.leader_parsed_city
      )
      expect(subject.parsed_state).to eq(
        leader_profile.leader_parsed_state
      )
      expect(subject.parsed_state_code).to eq(
        leader_profile.leader_parsed_state_code
      )
      expect(subject.parsed_postal_code).to eq(
        leader_profile.leader_parsed_postal_code
      )
      expect(subject.parsed_country).to eq(
        leader_profile.leader_parsed_country
      )
      expect(subject.parsed_country_code).to eq(
        leader_profile.leader_parsed_country_code
      )

      expect(subject.personal_website).to eq('https://orpheus.com')
      expect(subject.github_url).to eq('https://github.com/orpheus')
      expect(subject.linkedin_url).to eq('https://linkedin.com/in/orpheus')
      expect(subject.facebook_url).to eq('https://facebook.com/orpheus')
      expect(subject.twitter_url).to eq('https://twitter.com/orpheus')

      # links user
      expect(subject.user).to eq(leader_profile.user)
      expect(subject.user).to_not be_nil
    end

    it 'returns the leader object' do
      expect(@res).to eq(subject)
    end
  end

  describe ':calculate_expected_graduation in the 2015 - 2016 school year' do
    let(:current_date) { nil }

    before { travel_to current_date }
    after { travel_back }

    let(:year) { nil }
    subject { NewLeader.new.calculate_expected_graduation(year) }

    context 'in 2015' do
      let(:current_date) { Time.gm(2015, 10, 23) }

      context 'as a senior' do
        let(:year) { :senior }
        it { should eq Time.gm(2016, 6) }
      end

      context 'as a junior' do
        let(:year) { :junior }
        it { should eq Time.gm(2017, 6) }
      end

      context 'as a sophomore' do
        let(:year) { :sophomore }
        it { should eq Time.gm(2018, 6) }
      end

      context 'as a freshman' do
        let(:year) { :freshman }
        it { should eq Time.gm(2019, 6) }
      end

      context 'as anything else' do
        let(:year) { 'foo' }
        it { should eq nil }
      end
    end

    context 'in 2016' do
      let(:current_date) { Time.gm(2016, 0o2, 12) }

      context 'as a senior' do
        let(:year) { :senior }
        it { should eq Time.gm(2016, 6) }
      end

      context 'as a junior' do
        let(:year) { :junior }
        it { should eq Time.gm(2017, 6) }
      end

      context 'as a sophomore' do
        let(:year) { :sophomore }
        it { should eq Time.gm(2018, 6) }
      end

      context 'as a freshman' do
        let(:year) { :freshman }
        it { should eq Time.gm(2019, 6) }
      end

      context 'as anything else' do
        let(:year) { 'foo' }
        it { should eq nil }
      end
    end
  end
end
