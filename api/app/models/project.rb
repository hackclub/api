# frozen_string_literal: true
class Project < ApplicationRecord
  NOT_UNIQUE_MESSAGE = 'This project already exists'.freeze
  UNKNOWN_PROJECT_SOURCE_MESSAGE = 'This project type does not exist'.freeze

  validates :title, :data, presence: true

  validates :git_url, presence: true, if: [:github?, :cloud9_workshop?]

  before_create :unique?

  enum source: [
    :github,
    :github_workshop,
    :cloud9_workshop,
    :cloud9
  ]

  private

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def unique?
    res = if github_workshop?
            Project.where(local_dir: local_dir)
                   .where("data->>'id' = '?'", data['id']).empty?
          elsif github?
            # If the GitHub self ID has already been used, it's not unique
            Project.where("data->>'id' = '?'", data['id']).empty? &&
              Project.where(git_url: git_url).empty?
          elsif cloud9_workshop?
            # If the the Cloud9 self ID already exists, and the local_dir is
            # in use too
            Project.where(local_dir: local_dir)
                   .where("data->>'id' = ?", data['id']).empty?
          elsif cloud9?
            # If the Cloud9 self ID already exists
            Project.where("data->>'id' = ?", data['id']).empty?
          else
            errors.add(:base, UNKNOWN_PROJECT_SOURCE_MESSAGE)
            throw :abort
          end

    return if res

    errors.add(:base, NOT_UNIQUE_MESSAGE)

    throw :abort
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
end
