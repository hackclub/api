# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::BlockedEmailDomain, type: :model do
  subject { build(:users_blocked_email_domain) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :creator_id }
  it { should have_db_column :domain }

  it { should have_db_index(:domain).unique(true) }

  it { should belong_to :creator }

  it { should validate_presence_of :creator }
  it { should validate_presence_of :domain }
  it { should validate_uniqueness_of :domain }

  it 'should validate that domain actually just a domain' do
    expect(subject.valid?).to eq(true)

    subject.domain = 'http://google.com'
    expect(subject.valid?).to eq(false)

    subject.domain = 'http://username:password@google.com'
    expect(subject.valid?).to eq(false)

    subject.domain = 'google.com/foo'
    expect(subject.valid?).to eq(false)

    subject.domain = 'google.com?q=test'
    expect(subject.valid?).to eq(false)

    subject.domain = 'google.com'
    expect(subject.valid?).to eq(true)
  end
end
