# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadershipPositionInvite, type: :model do
  subject { create(:leadership_position_invite) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :sender_id }
  it { should have_db_column :new_club_id }
  it { should have_db_column :user_id }
  it { should have_db_column :accepted_at }
  it { should have_db_column :rejected_at }

  it { should belong_to :sender }
  it { should belong_to :new_club }
  it { should belong_to :user }

  it { should validate_presence_of :sender }
  it { should validate_presence_of :new_club }
  it { should validate_presence_of :user }

  it 'should not allow both accepted_at and rejected_at to be set' do
    expect(subject.valid?).to eq(true)

    subject.accepted_at = Time.current
    subject.rejected_at = Time.current

    expect(subject.valid?).to eq(false)
  end
end
