require 'rails_helper'

RSpec.describe Cloud9Invite, type: :model, vcr: true do
  subject { build(:cloud9_invite) }

  it { should have_db_column :team_name }
  it { should have_db_column :email }

  it { should validate_presence_of :team_name }
  it { should validate_presence_of :email }

  example do
    expect(subject).to validate_uniqueness_of(:email)
      .with_message('invite already sent for this email')
  end

  it 'ensures that only valid emails are accepted' do
    invite = build(:cloud9_invite)
    invite.email = 'bad_email'

    expect(invite).to be_invalid
    expect(invite.errors[:email]).to include('is not an email')
  end

  it 'sets the configured team name secret as the default' do
    configured_secret = Rails.application.secrets.cloud9_team_name

    expect(Cloud9Invite.new.team_name).to eq(configured_secret)
  end
end
