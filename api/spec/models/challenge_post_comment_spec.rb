# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengePostComment, type: :model do
  subject { build(:challenge_post_comment) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :user_id }
  it { should have_db_column :challenge_post_id }
  it { should have_db_column :parent_id }
  it { should have_db_column :body }

  it { should have_db_index :deleted_at }

  it_behaves_like 'Recoverable'

  it { should belong_to :user }
  it { should belong_to :challenge_post }
  it { should belong_to :parent }

  it { should validate_presence_of :user }
  it { should validate_presence_of :challenge_post }
  it { should validate_presence_of :body }
end
