class WorkshopProjectClick < ApplicationRecord
  belongs_to :workshop_project
  belongs_to :user

  enum type_of: %i{live code}
end
