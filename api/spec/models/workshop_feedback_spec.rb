# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkshopFeedback, type: :model do
  subject { build(:workshop_feedback) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :workshop_slug }
  it { should have_db_column :feedback }
  it { should have_db_column :ip_address }

  it { should validate_presence_of :workshop_slug }
  it { should validate_presence_of :feedback }
  it { should validate_presence_of :ip_address }

  it 'does not allow feedback to be an array' do
    expect(subject.valid?).to eq(true)

    subject.feedback = ['Test value']

    expect(subject.valid?).to eq(false)
  end
end
