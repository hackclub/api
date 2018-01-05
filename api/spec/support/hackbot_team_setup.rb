# frozen_string_literal: true

# Okay, so this is a little janky. Creating a club leader automatically does a
# lookup to try to resolve their given email to a Slack username.
#
# This will fail unless a Hackbot::Team is in the database with the default
# Slack team ID, since that's where it gets its access token from.
#
# The below is a concern that will add a before hook when included in any tests
# that will create a Hackbot::Team with a fake access token. Our actual calls to
# SlackClient are actually hitting our monkeypatched client in spec/support/, so
# we don't need to worry about having valid tokens.
module HackbotTeamSetup
  extend ActiveSupport::Concern

  included do
    before do
      Hackbot::Team.create(
        team_id: Rails.application.secrets.default_slack_team_id,
        team_name: 'Fake Team',
        bot_user_id: 'UFAKEUSER',
        bot_username: 'fake_username',
        bot_access_token: 'fake_token'
      )
    end
  end
end
