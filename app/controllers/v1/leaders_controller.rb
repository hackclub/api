module V1
  class LeadersController < ApplicationController
    before_action :verify_club_id, only: :intake

    TEAM_ID = Rails.application.secrets.slack_team_id

    def intake
      leader = Leader.new(
        leader_params.merge(club_ids: [club_id], slack_team_id: TEAM_ID)
      )

      if leader.save
        welcome_letter_for_leader(leader).save!
        welcome_message leader

        render json: leader, status: 201
      else
        render json: { errors: leader.errors }, status: 422
      end
    end

    protected

    def club_id
      params[:club_id]
    end

    def verify_club_id
      return unless club_id.nil?
      render json: { errors: { club_id: ["can't be blank"] } }, status: 422
    end

    def leader_params
      params.permit(
        :name, :email, :gender, :year, :phone_number, :slack_username,
        :github_username, :twitter_username, :address
      )
    end

    def welcome_letter_for_leader(leader)
      Letter.new(
        name: leader.name,
        # This is the type for club leaders
        letter_type: '9002',
        # This is the type for welcome letter + 3oz of stickers
        what_to_send: '9005',
        address: leader.address
      )
    end

    def welcome_message(leader)
      token = access_token leader
      return if token.nil?

      im = SlackClient::Chat.open_im(leader.slack_id, token)
      return if !im[:ok] || !im[:latest].nil?

      send_msg(im[:channel][:id], copy('welcome', first_name: leader.name))
    end

    def send_msg(channel, text)
      SlackClient::Chat.send_msg(
        channel,
        text,
        access_token(leader),
        as_user: true
      )
    end

    def copy(selector, values)
      cs = CopyService.new(values, values)

      cs.get_copy(selector)
    end

    def access_token(leader)
      t = team leader

      t.nil? ? nil : t.bot_access_token
    end

    def team(team_id)
      Hackbot::Team.find_by(team_id: team_id)
    end
  end
end
