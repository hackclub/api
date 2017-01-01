class V1::Hackbot::WebhookController < ApplicationController
  def callback
    # See https://api.slack.com/events/url_verification
    if params[:type] == 'url_verification'
      return render plain: params[:challenge]
    elsif params[:type] != 'event_callback'
      return render status: :not_implemented
    end

    slack_team = ::Hackbot::Team.find_by(team_id: params[:team_id])

    ::Hackbot::Dispatcher.new.handle(params[:event], slack_team)

    render status: 200
  end
end
