require 'rails_helper'

RSpec.describe AthulClub, type: :model, vcr: true do
  include HackbotTeamSetup

  subject do
    athul_club = build(:athul_club)

    # leader email needs to be an email of an account in slack for saving of
    # leaders to work.
    athul_club.leader.email = 'zach@hackclub.com'

    athul_club
  end

  it { should belong_to :club }
  it { should belong_to :leader }
  it { should belong_to :letter }

  it { should validate_presence_of :club }
  it { should validate_presence_of :leader }

  it 'only validates presence of letter after persistence' do
    expect(subject).to_not validate_presence_of :letter
    subject.save!
    expect(subject).to validate_presence_of :letter
  end
end
