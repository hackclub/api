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
  it { should have_db_column :website }
  it { should have_db_column :website_archived }
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

  ## validations ##

  it { should validate_presence_of :start }
  it { should validate_presence_of :end }
  it { should validate_presence_of :name }
  it { should validate_presence_of :website }
  it { should validate_presence_of :address }

  ## relations ##

  it { should have_one :logo }
  it { should have_one :banner }

  it_behaves_like 'Geocodeable'

  ## custom model stuff ##

  it 'queues rebuild triggers after committing changes' do
    expect do
      subject.update_attributes(name: 'New Name!')
    end.to have_enqueued_job(RebuildHackathonsSiteJob)
  end

  describe '#queue_notification_emails' do
    it 'sends notification email after creation if event is in the future' do
      expect(subject.start > Time.current).to be(true)
      expect do
        subject.save
      end.to have_enqueued_job(SendEventNotificationEmailsJob)
    end

    it 'does not sent notification if event is in the past' do
      subject.start = 3.days.ago
      expect do
        subject.save
      end.to_not have_enqueued_job(SendEventNotificationEmailsJob)
    end
  end

  it 'soft deletes, not permanently' do
    event = create(:event)

    event.destroy

    expect(Event.find_by(id: event.id)).to eq(nil)

    Event.with_deleted.find(event.id).restore

    expect(Event.find_by(id: event.id)).to_not eq(nil)
  end
end
