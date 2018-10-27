# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkshopProject, type: :model do
  subject { build(:workshop_project) }

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }

  it { should have_db_column :user_id }

  it { should have_db_column :workshop_slug }
  it { should have_db_column :code_url }
  it { should have_db_column :live_url }

  # relationships #

  it { should belong_to :user }
  it { should have_one :screenshot }

  # validations #

  it { should validate_presence_of :workshop_slug }
  it { should validate_presence_of :code_url }
  it { should validate_presence_of :live_url }
  it { should validate_presence_of :screenshot }

  it 'validates urls' do
    expect(subject.valid?).to eq(true)

    subject.code_url = 'notaurl'
    subject.live_url = 'notaurl'

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include(:code_url, :live_url)
  end

  it 'does not allow capitalization in workshop slugs' do
    expect(subject.valid?).to eq(true)

    subject.workshop_slug = 'Personal_Website'

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include(:workshop_slug)
  end

  it 'does not allow spaces in workshop slugs' do
    expect(subject.valid?).to eq(true)

    subject.workshop_slug = 'personal_website '

    expect(subject.valid?).to eq(false)
    expect(subject.errors).to include(:workshop_slug)
  end
end
