# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventGroup, type: :model do
  subject { build(:event_group) }

  # db #

  it { should have_db_column :id }
  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :name }
  it { should have_db_column :location }

  # relations #

  # TODO: it { should have_many :events }
  it { should have_one :logo }
  it { should have_one :banner }

  # validations #

  it { should validate_presence_of :name }
  it { should validate_presence_of :location }
end
