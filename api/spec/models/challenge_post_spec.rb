# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengePost, type: :model do
  subject { build(:challenge_post) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :name }
  it { should have_db_column :url }
  it { should have_db_column :description }
  it { should have_db_column :creator_id }
  it { should have_db_column :challenge_id }

  it { should belong_to :creator }
  it { should belong_to :challenge }
  it { should have_many :upvotes }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_presence_of :creator }
  it { should validate_presence_of :challenge }
end
