module Hackbot
  module Helpers
    extend ActiveSupport::Concern

    def access_token
      team.bot_access_token
    end

    def msg
      return nil unless event[:type] == 'message'

      event[:text]
    end

    def action
      return nil unless event[:type] == 'action'

      event[:action]
    end

    # Returns whether the current event being processed is a DM. Slack channel
    # IDs start with D if they're a direct message.
    def in_dm?
      event[:channel].starts_with? 'D'
    end

    def current_slack_user
      return nil unless event[:user]

      @_slack_user ||= SlackClient::Users.info(
        event[:user],
        access_token
      )[:user]
    end

    ADMIN_UIDS = Rails.application.secrets.hackbot_admins

    def current_admin?
      return true if ADMIN_UIDS.include? event[:user]

      false
    end
  end
end
