# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { build(:event) }

  ## db columns ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :start }
  it { should have_db_column :end }
  it { should have_db_column :name }
  it { should have_db_column :public }
  it { should have_db_column :website }
  it { should have_db_column :website_archived }
  it { should have_db_column :hack_club_associated }
  it { should have_db_column :hack_club_associated_notes }
  it { should have_db_column :collegiate }
  it { should have_db_column :total_attendance }
  it { should have_db_column :first_time_hackathon_estimate }
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

  ## concerns ##

  it_behaves_like 'Recoverable'
  it_behaves_like 'Geocodeable'

  ## validations ##

  it { should validate_presence_of :start }
  it { should validate_presence_of :end }
  it { should validate_presence_of :name }
  it { should validate_presence_of :website }
  it { should validate_presence_of :address }

  it 'requires public to be set' do
    expect(subject.valid?).to eq(true)

    subject.public = nil

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include('public')
  end

  it 'requires collegiate to be set' do
    expect(subject.valid?).to eq(true)

    subject.collegiate = nil

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include('collegiate')
  end

  describe 'hack_club_associated fields' do
    it 'requires hack_club_associated_notes to be set if associated' do
      expect(subject.valid?).to eq(true)

      subject.hack_club_associated = true

      expect(subject.valid?).to eq(false)
      expect(subject.errors).to include('hack_club_associated_notes')
    end

    it 'does not allow hack_club_associated to be nil' do
      expect(subject.valid?).to eq(true)

      subject.hack_club_associated = nil

      expect(subject.valid?).to eq(false)
      expect(subject.errors).to include('hack_club_associated')
    end
  end

  ## relations ##

  it { should have_one :logo }
  it { should have_one :banner }
  it { should have_many :photos }

  ## custom model stuff ##

  it 'queues rebuild triggers after committing changes' do
    expect do
      subject.update_attributes(name: 'New Name!')
    end.to have_enqueued_job(RebuildHackathonsSiteJob)
  end

  describe 'default values' do
    it 'true for public' do
      expect(Event.new.public).to eq(true)
    end

    it 'false for hack_club_associated' do
      expect(Event.new.hack_club_associated).to eq(false)
    end

    it 'false for collegiate' do
      expect(Event.new.collegiate).to eq(false)
    end
  end

  describe '#queue_notification_emails' do
    it 'sends notification email after creation if event is in the future' do
      expect(subject.start > Time.current).to be(true)
      expect do
        subject.save
      end.to have_enqueued_job(Events::NewEventEmailJob)
    end

    it 'does not sent notification if event is in the past' do
      subject.start = 3.days.ago
      expect do
        subject.save
      end.to_not have_enqueued_job(Events::NewEventEmailJob)
    end
  end

  describe '#website_redirect' do
    it 'returns nil when website is not persisted' do
      expect(subject.website_redirect).to be_nil
    end

    context 'after persistence' do
      before { subject.save }

      it 'returns redirect url as expected' do
        expect(subject.website_redirect).to include(
          "/v1/events/#{subject.id}/redirect"
        )
      end

      context 'with passed subscriber' do
        let(:subscriber) { create(:event_email_subscriber_confirmed) }

        it 'includes link tracking token' do
          expect(subject.website_redirect(subscriber)).to include(
            "?token=#{subscriber.link_tracking_token}"
          )
        end
      end
    end
  end
end
