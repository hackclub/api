require 'rails_helper'

RSpec.describe NewClubApplication, type: :model do
  ## db columns ##

  # relations
  it { should have_db_column :point_of_contact_id }

  # school
  it { should have_db_column :high_school_name }
  it { should have_db_column :high_school_url }
  it { should have_db_column :high_school_type }
  it { should have_db_column :high_school_address }
  it { should have_db_column :high_school_latitude }
  it { should have_db_column :high_school_longitude }
  it { should have_db_column :high_school_parsed_address }
  it { should have_db_column :high_school_parsed_city }
  it { should have_db_column :high_school_parsed_state }
  it { should have_db_column :high_school_parsed_state_code }
  it { should have_db_column :high_school_parsed_postal_code }
  it { should have_db_column :high_school_parsed_country }
  it { should have_db_column :high_school_parsed_country_code }

  # leaders
  it { should have_db_column :leaders_video_url }
  it { should have_db_column :leaders_interesting_project }
  it { should have_db_column :leaders_team_origin_story }

  # progress
  it { should have_db_column :progress_general }
  it { should have_db_column :progress_student_interest }
  it { should have_db_column :progress_meeting_yet }

  # idea
  it { should have_db_column :idea_why }
  it { should have_db_column :idea_other_coding_clubs }
  it { should have_db_column :idea_other_general_clubs }

  # formation
  it { should have_db_column :formation_registered }
  it { should have_db_column :formation_misc }

  # other
  it { should have_db_column :other_surprising_or_amusing_discovery }

  # curious
  it { should have_db_column :curious_what_convinced }
  it { should have_db_column :curious_how_did_hear }

  ## validations ##

  it_behaves_like 'Geocodeable'

  ## relationships ##

  it { should have_many(:applicant_profiles) }
  it { should have_many(:applicants).through(:applicant_profiles) }
  it { should belong_to(:point_of_contact) }

  it 'requires points of contact to be associated applicants' do
    bad_poc = create(:applicant)

    subject.update_attributes(point_of_contact: bad_poc)

    expect(subject.errors[:point_of_contact])
      .to include('must be an associated applicant')
  end
end
