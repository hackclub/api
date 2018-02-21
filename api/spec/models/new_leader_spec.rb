# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewLeader, type: :model do
  ## db columns ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :name }
  it { should have_db_column :email }
  it { should have_db_column :birthday }
  it { should have_db_column :expected_graduation }
  it { should have_db_column :gender }
  it { should have_db_column :ethnicity }
  it { should have_db_column :phone_number }
  it { should have_db_column :address }
  it { should have_db_column :latitude }
  it { should have_db_column :longitude }
  it { should have_db_column :parsed_address }
  it { should have_db_column :parsed_city }
  it { should have_db_column :parsed_state }
  it { should have_db_column :parsed_state_code }
  it { should have_db_column :parsed_postal_code }
  it { should have_db_column :parsed_country }
  it { should have_db_column :parsed_country_code }
  it { should have_db_column :personal_website }
  it { should have_db_column :github_url }
  it { should have_db_column :linkedin_url }
  it { should have_db_column :facebook_url }
  it { should have_db_column :twitter_url }

  ## types ##

  it { should define_enum_for :gender }
  it { should define_enum_for :ethnicity }

  ## associations ##

  it { should have_many(:leadership_positions) }
  it { should have_many(:new_clubs).through(:leadership_positions) }

  ## validations ##

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :expected_graduation }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :ethnicity }
  it { should validate_presence_of :phone_number }
  it { should validate_presence_of :address }
end
