# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FundraisingDeal, type: :model do
  subject { build(:fundraising_deal) }

  it_behaves_like 'Streakable'

  it { should have_db_column :name }
  it { should have_db_column :streak_key }
  it { should have_db_column :stage_key }
  it { should have_db_column :actual_amount }
  it { should have_db_column :target_amount }
  it { should have_db_column :probability_of_close }
  it { should have_db_column :source }
  it { should have_db_column :notes }

  it { should validate_presence_of :name }
end
