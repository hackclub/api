# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewClub, type: :model do
  subject { build(:new_club) }

  ## db columns ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :died_at }
  it { should have_db_column :owner_id }
  it { should have_db_column :high_school_name }
  it { should have_db_column :high_school_url }
  it { should have_db_column :high_school_type }
  it { should have_db_column :high_school_address }
  it { should have_db_column :high_school_latitude }
  it { should have_db_column :high_school_parsed_address }
  it { should have_db_column :high_school_parsed_city }
  it { should have_db_column :high_school_parsed_state }
  it { should have_db_column :high_school_parsed_state_code }
  it { should have_db_column :high_school_parsed_postal_code }
  it { should have_db_column :high_school_parsed_country }
  it { should have_db_column :high_school_parsed_country_code }
  it { should have_db_column :high_school_start_month }
  it { should have_db_column :high_school_end_month }
  it { should have_db_column :club_website }
  it { should have_db_column :send_check_ins }

  it { should have_db_index :died_at }

  ## types ##

  it { should define_enum_for :high_school_type }

  ## associations ##

  it { should belong_to :owner }

  it { should have_many(:new_club_applications) }
  it { should have_many(:leadership_positions) }
  it { should have_many(:leadership_position_invites) }
  it { should have_many(:information_verification_requests) }
  it { should have_many(:new_leaders).through(:leadership_positions) }
  it { should have_many(:notes) }

  it { should have_one :club }

  ## validations ##

  it { should validate_presence_of :high_school_name }
  it { should validate_presence_of :high_school_address }

  it 'should not allow send_check_ins to be nil' do
    expect(subject.valid?).to eq(true)

    subject.send_check_ins = nil

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include(:send_check_ins)
  end

  it 'should not allow start or end months to be out of bounds' do
    fields = %i[high_school_start_month high_school_end_month]

    fields.each do |field|
      # so we can reset
      start_val = subject.send(field)

      expect(subject.valid?).to eq(true)

      # too low
      subject.send("#{field}=", -1)
      expect(subject.valid?).to eq(false)

      # good
      subject.send("#{field}=", 5)
      expect(subject.valid?).to eq(true)

      # too high
      subject.send("#{field}=", 12)
      expect(subject.valid?).to eq(false)

      # reset
      subject.send("#{field}=", start_val)
      expect(subject.valid?).to eq(true)
    end
  end

  ## other ##

  it_behaves_like 'Geocodeable'

  describe '#dead scoping' do
    before { subject.save }

    it "doesn't include subject" do
      expect(NewClub.dead).to_not include(subject)
    end

    context 'when died_at is set on subject' do
      before { subject.update_attributes(died_at: Time.current) }

      it 'includes subject' do
        expect(NewClub.dead).to include(subject)
      end
    end
  end

  describe ':from_application' do
    let(:application) do
      create(:submitted_new_club_application, profile_count: 3)
    end

    let(:app) { application } # alias for convenience

    before { subject.from_application(application) }

    it 'properly sets club fields' do
      expect(subject.high_school_name).to eq(app.high_school_name)
      expect(subject.high_school_url).to eq(app.high_school_url)
      expect(subject.high_school_type).to eq(app.high_school_type)
      expect(subject.high_school_address).to eq(app.high_school_address)
      expect(subject.high_school_latitude).to eq(app.high_school_latitude)
      expect(subject.high_school_longitude).to eq(app.high_school_longitude)

      expect(
        subject.high_school_parsed_address
      ).to eq(app.high_school_parsed_address)
      expect(
        subject.high_school_parsed_city
      ).to eq(app.high_school_parsed_city)
      expect(
        subject.high_school_parsed_state
      ).to eq(app.high_school_parsed_state)
      expect(
        subject.high_school_parsed_state_code
      ).to eq(app.high_school_parsed_state_code)
      expect(
        subject.high_school_parsed_postal_code
      ).to eq(app.high_school_parsed_postal_code)
      expect(
        subject.high_school_parsed_country
      ).to eq(app.high_school_parsed_country)
      expect(
        subject.high_school_parsed_country_code
      ).to eq(app.high_school_parsed_country_code)
    end

    it 'properly creates leader objects' do
      expect(subject.new_leaders.size).to eq(3)
      # tests for properly setting leader fields are in the leader spec
    end
  end
end
