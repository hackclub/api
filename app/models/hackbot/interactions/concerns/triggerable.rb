module Hackbot
  module Interactions
    module Concerns
      module Triggerable
        extend ActiveSupport::Concern

        SLACK_TEAM_ID = Rails.application.secrets.slack_team_id

        class_methods do
          def trigger(user_id, team = nil)
            team ||= Hackbot::Team.find_by(team_id: SLACK_TEAM_ID)
            event = FakeSlackEventService.new(team, user_id).event
            interaction = new(event: event, team: team)
            interaction.handle
            interaction.save!
            interaction
          end
        end
      end
    end
  end
end
