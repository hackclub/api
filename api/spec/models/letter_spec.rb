require 'rails_helper'

RSpec.describe Letter, type: :model do
  subject { build(:letter) }

  it_behaves_like 'Streakable'

  it { should have_db_column :name }
  it { should have_db_column :letter_type }
  it { should have_db_column :what_to_send }
  it { should have_db_column :address }
  it { should have_db_column :final_weight }
  it { should have_db_column :notes }

  it { should validate_presence_of :name }
  it { should validate_presence_of :address }
  it { should validate_uniqueness_of :streak_key }
end
