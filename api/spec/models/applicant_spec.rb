require 'rails_helper'

RSpec.describe Applicant, type: :model do
  subject { build(:applicant) }

  it { should have_db_column :email }
  it { should have_db_column :login_code }
  it { should have_db_column :auth_token }

  it { should validate_presence_of :email }
  it { should validate_email_format_of :email }

  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :login_code }
  it { should validate_uniqueness_of :auth_token }

  example ':generate_login_code' do
    subject.login_code = nil
    subject.login_code_generation = nil

    subject.generate_login_code

    # generates correctly
    expect(subject.login_code.class).to be(String)
    expect(subject.login_code).to match(/\d{6}/)
    expect(subject.login_code_generation).to be_within(1.second).of(Time.now)

    # changes every time
    expect{subject.generate_login_code}.to change{subject.login_code}
  end

  example ':generate_auth_token' do
    subject.auth_token = nil
    subject.auth_token_generation = nil

    subject.generate_auth_token

    # generates correctly
    expect(subject.auth_token).to match(/[\d\D]{32}/)
    expect(subject.auth_token_generation).to be_within(1.second).of(Time.now)

    # changes every time
    expect{subject.generate_auth_token}.to change{subject.auth_token}
  end
end
