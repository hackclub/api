# frozen_string_literal: true

# Okay, so this is a little janky. Creating a club leader automatically does a
# lookup to try to resolve their given email to a Slack username.
#
# This will fail unless a Hackbot::Team is in the database with the default
# Slack team ID, since that's where it gets its access token from.
#
# The below is a concern that will add a before hook when included in any tests
# that will create a Hackbot::Team with an access token from the environment.
module HackbotTeamSetup
  extend ActiveSupport::Concern

  included do
    before do
      token = Rails.application.secrets.spec_slack_access_token

      unless token
        throw 'HackbotTeamSetup included and SPEC_SLACK_ACCESS_TOKEN not set.'
      end

      Hackbot::Team.create(
        team_id: Rails.application.secrets.default_slack_team_id,
        team_name: 'Hack Club',
        bot_user_id: 'U3M0Q1CJ3', # @orpheus's ID on the main Slack
        bot_username: 'orpheus',
        bot_access_token: token
      )
    end
  end
end
