require 'rails_helper'

RSpec.describe ApplicantProfile, type: :model do
  ## db columns ##

  # relations
  it { should have_db_column :applicant_id }
  it { should have_db_column :new_club_application_id }

  # leader
  it { should have_db_column :leader_name }
  it { should have_db_column :leader_email }
  it { should have_db_column :leader_age }
  it { should have_db_column :leader_year_in_school }
  it { should have_db_column :leader_gender }
  it { should have_db_column :leader_ethnicity }
  it { should have_db_column :leader_phone_number }
  it { should have_db_column :leader_address }
  it { should have_db_column :leader_latitude }
  it { should have_db_column :leader_longitude }
  it { should have_db_column :leader_parsed_address }
  it { should have_db_column :leader_parsed_city }
  it { should have_db_column :leader_parsed_state }
  it { should have_db_column :leader_parsed_state_code }
  it { should have_db_column :leader_parsed_postal_code }
  it { should have_db_column :leader_parsed_country }
  it { should have_db_column :leader_parsed_country_code }

  # presence
  it { should have_db_column :presence_personal_website }
  it { should have_db_column :presence_github_url }
  it { should have_db_column :presence_linkedin_url }
  it { should have_db_column :presence_facebook_url }
  it { should have_db_column :presence_twitter_url }

  # skills
  it { should have_db_column :skills_system_hacked }
  it { should have_db_column :skills_impressive_achievement }
  it { should have_db_column :skills_is_technical }

  ## validations ##

  it { should validate_presence_of :applicant }
  it { should validate_presence_of :new_club_application }

  it_behaves_like 'Geocodeable'

  ## relationships ##

  it { should belong_to :applicant }
  it { should belong_to :new_club_application }
end
