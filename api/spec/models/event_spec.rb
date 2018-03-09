require 'rails_helper'

RSpec.describe Event, type: :model do
  ## db columns ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :start }
  it { should have_db_column :end }
  it { should have_db_column :name }
  it { should have_db_column :website }
  it { should have_db_column :website_archived }
  it { should have_db_column :total_attendance }
  it { should have_db_column :first_time_hackathon_estimate }
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

  ## validations ##

  it { should validate_presence_of :start }
  it { should validate_presence_of :end }
  it { should validate_presence_of :name }
  it { should validate_presence_of :address }

  it_behaves_like 'Geocodeable'
end
