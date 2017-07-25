require 'rails_helper'

RSpec.describe NetPromoterScoreSurvey, type: :model do
  it { should have_db_column :score }
  it { should have_db_column :could_improve }
  it { should have_db_column :done_well }
  it { should have_db_column :anything_else }

  it { should belong_to :leader }

  it { should validate_presence_of :score }
  it { should validate_presence_of :could_improve }
  it { should validate_presence_of :done_well }
end
