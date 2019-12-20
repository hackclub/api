# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginCode, type: :model do
  subject { build(:login_code) }

  ## db column ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :user_id }
  it { should have_db_column :code }
  it { should have_db_column :ip_address }
  it { should have_db_column :user_agent }
  it { should have_db_column :used_at }

  ## validations ##

  it { should validate_presence_of :user }
  it { should validate_presence_of :code }
  it { should validate_uniqueness_of :code }

  ## relations ##

  it { should belong_to :user }

  ## custom model stuff ##

  it 'automatically generates codes' do
    expect(LoginCode.new.code).to match(/\d{6}/)
  end

  example '#pretty' do
    subject.code = '123456'

    expect(subject.pretty).to eq('123-456')
  end
end
