# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { should have_db_column :email }
  it { should have_db_column :username }
  it { should have_db_column :login_code }
  it { should have_db_column :login_code_generation }
  it { should have_db_column :auth_token }
  it { should have_db_column :auth_token_generation }
  it { should have_db_column :admin_at }
  it { should have_db_column :email_on_new_challenges }
  it { should have_db_column :email_on_new_challenge_posts }
  it { should have_db_column :email_on_new_challenge_post_comments }
  it { should have_db_column :new_leader_id }

  it { should have_db_index(:username).unique(true) }

  it { should validate_presence_of :email }
  it { should validate_email_format_of :email }

  # had to write a custom validation for uniqueness of emails, at bottom of
  # this file
  it { should validate_uniqueness_of :username }
  it { should validate_uniqueness_of :login_code }
  it { should validate_uniqueness_of :auth_token }

  it ' should not allow email_on_new_challenges to be nil' do
    expect(subject.valid?).to eq(true)

    subject.email_on_new_challenges = nil

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include('email_on_new_challenges')
  end

  it 'should not allow email_on_new_challenge_posts to be nil' do
    expect(subject.valid?).to eq(true)

    subject.email_on_new_challenge_posts = nil

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include('email_on_new_challenge_posts')
  end

  it 'should not allow email_on_new_challenge_post_comments to be nil' do
    expect(subject.valid?).to eq(true)

    subject.email_on_new_challenge_post_comments = nil

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include('email_on_new_challenge_post_comments')
  end

  it 'does not allow duplicate emails to be created, regardless of case' do
    create(:user, email: 'existinguser@gmail.com')

    subject.email = 'ExistingUser@gmail.com'
    expect(subject.valid?).to eq(false)
  end

  it 'requires usernames to be lowercase' do
    expect(subject.valid?).to eq(true)

    subject.username = 'FooBar'

    expect(subject.valid?).to eq(false)
  end

  it 'requires usernames to be at least one character' do
    expect(subject.valid?).to eq(true)

    subject.username = ''

    expect(subject.valid?).to eq(false)
  end

  it "doesn't allow users to unset usernames" do
    subject.username = 'foobar'
    subject.save!

    subject.username = nil
    expect(subject.valid?).to eq(false)
  end

  it { should belong_to(:new_leader) }
  it { should have_many(:leader_profiles) }
  it { should have_many(:new_club_applications).through(:leader_profiles) }

  it 'lowercases provided email' do
    subject.email = 'CamelCase@gmail.com'
    subject.save
    expect(subject.email).to eq('camelcase@gmail.com')
  end

  it 'sets email_on_new_challenges to false by default' do
    expect(User.new.email_on_new_challenges).to eq(false)
  end

  it 'sets email_on_new_challenge_posts to false by default' do
    expect(User.new.email_on_new_challenge_posts).to eq(false)
  end

  it 'sets email_on_new_challenge_post_comments to true by default' do
    expect(User.new.email_on_new_challenge_post_comments).to eq(true)
  end

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
end
