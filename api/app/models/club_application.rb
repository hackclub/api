# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class ClubApplication < ApplicationRecord
  include Streakable

  streak_pipeline_key(
    Rails.application.secrets.streak_club_applications_pipeline_key
  )

  streak_default_field_mappings key: :streak_key, name: :high_school,
                                notes: :notes, stage: :stage_key

  YEARS = {
    '2016' => '9007',
    '2017' => '9006',
    '2018' => '9005',
    '2019' => '9004',
    '2020' => '9003',
    '2021' => '9002',
    '2022' => '9001',
    'Graduated' => '9008',
    'Teacher' => '9009',
    'Unknown' => '9010'
  }.freeze

  streak_field_mappings(
    first_name: '1010',
    last_name: '1011',
    email: '1012',
    github: '1013',
    twitter: '1014',
    phone_number: '1019',
    interesting_project: '1015',
    systems_hacked: '1016',
    steps_taken: '1017',
    referer: '1018',
    year: {
      key: '1020',
      type: 'DROPDOWN',
      options: YEARS
    },
    application_quality: {
      key: '1009',
      type: 'DROPDOWN',
      options: {
        'Satisfactory' => '9001',
        'Above Average' => '9002',
        'Excellent' => '9003',
        'Unknown' => '9004'
      }
    },
    rejection_reason: {
      key: '1004',
      type: 'DROPDOWN',
      options: {
        'Spam' => '9001',
        'Not High School Student' => '9002',
        'Did not respond to acceptance email' => '9004',
        'Bad timing' => '9005',
        'Not enough detail' => '9006',
        'Teacher' => '9007',
        'Merged with another application' => '9008',
        'Bad fit' => '9009',
        'Unknown' => '9010',
        "Didn't show to onboarding call" => '9011',
        "Didn't show to interview" => '9012'
      }
    },
    source: {
      key: '1003',
      type: 'DROPDOWN',
      options: {
        'Word of Mouth' => '9001',
        'Unknown' => '9002',
        'Free Code Camp' => '9003',
        'GitHub' => '9004',
        'Press' => '9005',
        'Searching online' => '9006',
        'Hackathon' => '9007',
        'Website' => '9008',
        'Social media' => '9009',
        'Hack Camp' => '9010',
        'Hacker News' => '9011',
        'French TV' => '9012',
        'Code HS' => '9013',
        'Direct Marketing' => '9014',
        'Direct Marketing - Emailing Teachers' => '9016',
        'Direct Marketing - GitHub Outreach' => '9018',
        'Facebook Ad' => '9015',
        'Product Hunt' => '9017',
        'Direct Marketing - CodeDay Outreach' => '9019',
        'Matthew Email Campaign' => '9020',
        'Github Outreach—Hackathon Participant' => '9021'
      }
    },
    legacy_year: '1023'
  )

  streak_read_only spam: '1021', g_id: '1024'

  validates :first_name, :last_name, :email, :high_school, :interesting_project,
            :systems_hacked, :steps_taken, :referer, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def g_id
    id
  end

  def spam
    spam?.to_s
  end

  def spam?
    ClubApplicationSpamService.new.spam? self
  end

  def mail_address
    expected = Mail::Address.new email
    expected.display_name = full_name

    expected
  end

  # Convert the Streak key into a human readable string, conversions as
  # defined in pretty_year.
  def pretty_year
    YEARS.select { |_, v| v == year }.first[0]
  end
end
# rubocop:enable Metrics/ClassLength
