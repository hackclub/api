class Project < ApplicationRecord
  validates :title, :description, :git_url, :workspace, present: true
end
