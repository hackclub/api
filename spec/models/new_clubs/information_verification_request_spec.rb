# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewClubs::InformationVerificationRequest, type: :model do
  subject { build(:new_clubs_information_verification_request) }

  ## db columns ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :new_club_id }
  it { should have_db_column :verified_at }
  it { should have_db_column :verifier_id }

  ## associations ##

  it { should belong_to(:new_club) }
  it { should belong_to(:verifier) }

  ## validations ##

  it { should validate_presence_of :new_club }

  context 'when verified_at is set' do
    before { subject.update(verified_at: Time.current) }

    it { should validate_presence_of :verifier }
  end

  context 'when verifier is set' do
    before { subject.update(verifier: create(:user)) }

    it { should validate_presence_of :verified_at }
  end

  context 'when verified' do
    before do
      subject.update(verified_at: Time.current, verifier: create(:user))
    end

    it 'does not allow verified_at to be unset' do
      subject.update(verified_at: nil, verifier: nil)

      expect(subject.valid?).to eq(false)
    end

    it 'does not allow verified_at to be changed' do
      subject.update(verified_at: 1.minute.from_now)

      expect(subject.valid?).to eq(false)
    end
  end
end
