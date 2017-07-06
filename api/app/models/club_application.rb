class ClubApplication < ApplicationRecord
  validates :first_name, :last_name, :email, :github, :twitter, :high_school,
    :interesting_project, :systems_hacked, :steps_taken, :year, :referer,
    :phone_number, :start_date, presence: true
end
