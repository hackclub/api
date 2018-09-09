# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventEmailSubscriber, type: :model do
  subject { build(:event_email_subscriber) }

  ## db setup ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :email }
  it { should have_db_column :location }

  # geocoded fields
  it { should have_db_column :latitude }
  it { should have_db_column :longitude }
  it { should have_db_column :parsed_address }
  it { should have_db_column :parsed_city }
  it { should have_db_column :parsed_state }
  it { should have_db_column :parsed_state_code }
  it { should have_db_column :parsed_postal_code }
  it { should have_db_column :parsed_country }
  it { should have_db_column :parsed_country_code }

  # for unsubscriptions
  it { should have_db_column :unsubscribed_at }
  it { should have_db_column :unsubscribe_token }

  # for confirming the email is valid
  it { should have_db_column :confirmed_at }
  it { should have_db_column :confirmation_token }

  # for link tracking
  it { should have_db_column :link_tracking_token }

  it { should have_db_index(:email).unique(true) }
  it { should have_db_index(:unsubscribe_token).unique(true) }
  it { should have_db_index(:confirmation_token).unique(true) }
  it { should have_db_index(:link_tracking_token).unique(true) }

  ## validations ##

  it { should validate_presence_of :email }
  it { should validate_presence_of :location }

  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :unsubscribe_token }
  it { should validate_uniqueness_of :confirmation_token }
  it { should validate_uniqueness_of :link_tracking_token }

  ## other stuff ##

  it_behaves_like 'Geocodeable'

  it 'generates unsubscription token on creation' do
    expect(subject.persisted?).to eq(false)
    subject.save
    expect(subject.unsubscribe_token).to match(/.{32}/)
  end

  it 'generates confirmation token on creation' do
    expect(subject.persisted?).to eq(false)
    subject.save
    expect(subject.confirmation_token).to match(/.{32}/)
  end

  it 'generates link tracking token on creation' do
    expect(subject.persisted?).to eq(false)
    subject.save
    expect(subject.link_tracking_token).to match(/.{32}/)
  end

  it 'queues rebuild triggers after committing changes' do
    expect do
      subject.update_attributes(email: 'foo@bar.com')
    end.to have_enqueued_job(RebuildHackathonsSiteJob)
  end
end
