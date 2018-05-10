# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AthulClub, type: :model do
  include HackbotTeamSetup

  subject do
    athul_club = build(:athul_club)

    # leader email needs to be an email of an account in slack for saving of
    # leaders to work.
    athul_club.leader.email = 'john@johndoe.com'

    athul_club
  end

  before { SlackClient::Users.gen_user(profile: { email: 'john@johndoe.com' }) }
  after { SlackClient::Users.reset }

  it { should belong_to :club }
  it { should belong_to :leader }
  it { should belong_to :letter }

  it { should validate_presence_of :club }
  it { should validate_presence_of :leader }

  it 'requires address to be set on leader' do
    expect(subject).to be_valid
    subject.leader.address = nil
    expect(subject).to be_invalid
  end

  it 'only validates presence of letter after persistence' do
    expect(subject).to_not validate_presence_of :letter
    subject.save!
    expect(subject).to validate_presence_of :letter
  end
end
