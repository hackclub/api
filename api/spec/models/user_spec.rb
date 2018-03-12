# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { should have_db_column :email }
  it { should have_db_column :login_code }
  it { should have_db_column :login_code_generation }
  it { should have_db_column :auth_token }
  it { should have_db_column :auth_token_generation }
  it { should have_db_column :admin_at }

  it { should validate_presence_of :email }
  it { should validate_email_format_of :email }

  # had to write a custom validation for uniqueness, at bottom of this file
  it { should validate_uniqueness_of :login_code }
  it { should validate_uniqueness_of :auth_token }

  it { should have_many(:leader_profiles) }
  it { should have_many(:new_club_applications).through(:leader_profiles) }

  example ':generate_login_code!' do
    subject.login_code = nil
    subject.login_code_generation = nil

    subject.generate_login_code!

    # generates correctly
    expect(subject.login_code.class).to be(String)
    expect(subject.login_code).to match(/\d{6}/)
    expect(
      subject.login_code_generation
    ).to be_within(1.second).of(Time.current)

    # changes every time
    expect { subject.generate_login_code! }.to change { subject.login_code }
  end

  example ':pretty_login_code' do
    subject.login_code = '123456'

    expect(subject.pretty_login_code).to eq('123-456')
  end

  example ':generate_auth_token!' do
    subject.auth_token = nil
    subject.auth_token_generation = nil

    subject.generate_auth_token!

    # generates correctly
    expect(subject.auth_token).to match(/[\d\D]{32}/)
    expect(
      subject.auth_token_generation
    ).to be_within(1.second).of(Time.current)

    # changes every time
    expect { subject.generate_auth_token! }.to change { subject.auth_token }
  end

  example ':make_admin!' do
    subject.admin_at = nil

    subject.make_admin!

    expect(subject.admin_at).to be_within(1.second).of(Time.current)
    expect(subject.admin?).to eq(true)
  end

  example ':remove_admin!' do
    subject.admin_at = nil

    subject.make_admin!
    expect(subject.admin?).to eq(true)

    subject.remove_admin!
    expect(subject.admin_at).to eq(nil)
    expect(subject.admin?).to eq(false)
  end

  it 'lowercases the provided email' do
    subject.email = 'CamelCase@gmail.com'
    subject.save
    expect(subject.email).to eq('camelcase@gmail.com')
  end

  it 'does not allow duplicate emails to be created, regardless of case' do
    create(:user, email: 'existinguser@gmail.com')

    subject.email = 'ExistingUser@gmail.com'
    expect(subject.valid?).to eq(false)
  end
end
