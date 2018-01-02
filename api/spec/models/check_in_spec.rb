# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckIn, type: :model do
  it { should have_db_column :club_id }
  it { should have_db_column :leader_id }
  it { should have_db_column :meeting_date }
  it { should have_db_column :attendance }
  it { should have_db_column :notes }

  it { should belong_to :club }
  it { should belong_to :leader }

  it { should validate_presence_of :club }
  it { should validate_presence_of :leader }
  it { should validate_presence_of :meeting_date }
  it { should validate_presence_of :attendance }
end
