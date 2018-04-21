# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  subject { build(:note) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :noteable_type }
  it { should have_db_column :noteable_id }
  it { should have_db_column :user_id }
  it { should have_db_column :body }

  it_behaves_like 'Recoverable'

  it { should belong_to :noteable }
  it { should belong_to :user }

  it { should validate_presence_of :user }
  it { should validate_presence_of :body }
end
