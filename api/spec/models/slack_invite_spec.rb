
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlackInvite, type: :model, vcr: true do
  subject { build(:slack_invite) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :email }

  it { should have_db_index(:email).unique(true) }

  it { should validate_presence_of :email }
  it { should validate_email_format_of :email }
  it { should validate_uniqueness_of(:email).case_insensitive }

  it 'successfully creates' do
    expect(subject.save).to eq(true)
    expect(subject.persisted?).to eq(true)
  end
end
