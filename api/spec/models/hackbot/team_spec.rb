# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hackbot::Team, type: :model do
  it { should have_db_column :team_id }
  it { should have_db_column :team_name }
  it { should have_db_column :bot_user_id }
  it { should have_db_column :bot_access_token }
  it { should have_db_column :bot_username }

  it { should validate_presence_of :team_id }
  it { should validate_presence_of :team_name }
  it { should validate_presence_of :bot_user_id }
  it { should validate_presence_of :bot_access_token }
  it { should validate_presence_of :bot_username }

  it { should validate_uniqueness_of :team_id }
  it { should validate_uniqueness_of :bot_user_id }
  it { should validate_uniqueness_of :bot_access_token }

  it { should have_many :interactions }
end
