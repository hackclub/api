# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Challenge, type: :model do
  subject { build(:challenge) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :name }
  it { should have_db_column :description }
  it { should have_db_column :start }
  it { should have_db_column :end }
  it { should have_db_column :creator_id }

  it { should belong_to :creator }

  it { should validate_presence_of :name }
  it { should validate_presence_of :start }
  it { should validate_presence_of :end }
  it { should validate_presence_of :creator }

  it 'should not allow end to be before start' do
    expect(subject.valid?).to eq(true)

    subject.end = 2.days.ago
    subject.start = 1.day.ago

    expect(subject.valid?).to eq(false)
  end
end
