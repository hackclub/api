# frozen_string_literal: true

module Hackbot
  module Interactions
    module Concerns
      module Triggerable
        extend ActiveSupport::Concern

        SLACK_TEAM_ID = Rails.application.secrets.default_slack_team_id

        class_methods do
          # This constructs a fake Slack event to start the interaction with.
          # It'll be sent to the interaction's start method.
          def trigger(user_id, team = nil, channel_id = nil)
            team ||= Hackbot::Team.find_by(team_id: SLACK_TEAM_ID)
            event = FakeSlackEventService.new(team, user_id, channel_id).event
            interaction = create(event: event, team: team)
            interaction.handle
            interaction.save!
            interaction
          end
        end
      end
    end
  end
end
