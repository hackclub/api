class HandleSlackEventJob < ApplicationJob
  def perform(event, team_id)
    slack_team = ::Hackbot::Team.find_by(team_id: team_id)

    ::Hackbot::Dispatcher.new.handle(event, slack_team)
  end
end
