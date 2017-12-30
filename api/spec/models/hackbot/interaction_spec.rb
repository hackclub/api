# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hackbot::Interaction, type: :model do
  it { should have_db_column :type }
  it { should have_db_column :hackbot_team_id }
  it { should have_db_column :state }
  it { should have_db_column :data }

  it { should validate_presence_of :team }
  it { should validate_presence_of :state }

  it { should belong_to :team }
end
