# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengePostClick, type: :model do
  subject { build(:challenge_post_click) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :challenge_post_id }
  it { should have_db_column :user_id }
  it { should have_db_column :ip_address }
  it { should have_db_column :referer }
  it { should have_db_column :user_agent }

  it_behaves_like 'Recoverable'

  it { should belong_to(:challenge_post).counter_cache(:click_count) }
  it { should belong_to :user }

  it { should validate_presence_of :challenge_post }
  it { should validate_presence_of :ip_address }
end
