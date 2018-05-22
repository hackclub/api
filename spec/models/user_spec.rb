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
  it { should have_db_column :shadow_banned_at }
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

  it 'should not allow boolean values to be nil' do
    fields = %i[
      email_on_new_challenges
      email_on_new_challenge_posts
      email_on_new_challenge_post_comments
    ]

    fields.each do |field|
      old_val = subject.send(field)

      expect(subject.valid?).to eq(true)

      subject.send("#{field}=", nil) # set to nil

      expect(subject.valid?).to eq(false)
      expect(subject.errors).to include(field)

      subject.send("#{field}=", old_val) # reset val
    end
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
  it { should have_many(:leadership_position_invites) }
  it { should have_many(:leader_profiles) }
  it { should have_many(:new_club_applications).through(:leader_profiles) }

  it 'properly sets default values' do
    expect(User.new.email_on_new_challenges).to eq(false)
    expect(User.new.email_on_new_challenge_posts).to eq(false)
    expect(User.new.email_on_new_challenge_post_comments).to eq(true)
  end

  it 'lowercases provided email' do
    subject.email = 'CamelCase@gmail.com'
    subject.save
    expect(subject.email).to eq('camelcase@gmail.com')
  end

  describe 'automatic setting of usernames' do
    context 'when username is provided' do
      before { subject.username = 'myuniqueusername' }

      it 'does not change username' do
        subject.save
        expect(subject.username).to eq('myuniqueusername')
      end
    end

    context 'when username is not provided' do
      before { subject.email = 'jeremy@example.com' }
      it 'truncates email' do
        subject.save
        expect(subject.username).to eq('jeremy')
      end

      context '& email has special chars' do
        before { subject.email = '_jerEm4*2+3@example.com' }

        it 'removes special chars' do
          subject.save
          expect(subject.username).to eq('jerem423')
        end
      end

      context 'and a username conflict exists' do
        before do
          create(:user, username: 'jeremy')
          create(:user, username: 'jeremy2')
        end

        it 'picks an unused username' do
          subject.save
          expect(subject.username).to eq('jeremy3')
        end
      end
    end
  end

  describe 'automatic shadowbanning' do
    context 'when email is from a blocked domain' do
      before { create(:users_blocked_email_domain, domain: 'foobar.com') }

      it 'automatically shadowbans the user' do
        expect(subject.shadow_banned?).to eq(false)

        subject.email = 'foo@foobar.com'
        subject.save

        expect(subject.shadow_banned?).to eq(true)
      end
    end

    context 'when email is not from a blocked domain' do
      it 'does not shadowban the user' do
        expect(subject.shadow_banned?).to eq(true)

        subject.save

        expect(subject.shadow_banned?).to eq(false)
      end
    end
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

  describe 'shadow_banned_at' do
    describe ':shadow_ban!' do
      it 'works as expected' do
        expect(subject.shadow_banned?).to eq(false)

        subject.shadow_ban!

        expect(subject.shadow_banned?).to eq(true)
      end
    end

    describe ':shadow_banned?' do
      it 'works as expected' do
        expect(subject.shadow_banned?).to eq(false)

        subject.shadow_banned_at = Time.current

        expect(subject.shadow_banned?).to eq(true)
      end
    end
  end
end
