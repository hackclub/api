# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadershipPosition, type: :model do
  subject { build(:leadership_position) }

  ## db columns ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :deleted_at }
  it { should have_db_column :new_club_id }
  it { should have_db_column :new_leader_id }

  it { should have_db_index(:deleted_at) }

  ## concerns ##

  it_behaves_like 'Recoverable'

  ## associations ##

  it { should belong_to :new_club }
  it { should belong_to :new_leader }

  ## validations ##

  it { should validate_presence_of :new_club }
  it { should validate_presence_of :new_leader }
end
