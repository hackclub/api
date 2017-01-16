module V1
  module Hackbot
    class AuthController < ApplicationController
      CLIENT_ID = Rails.application.secrets.slack_client_id
      CLIENT_SECRET = Rails.application.secrets.slack_client_secret

      def create
        resp = ::SlackClient::Oauth.access(CLIENT_ID, CLIENT_SECRET, code)

        return render status: 403 unless resp[:ok]

        if ::Hackbot::Team.exists?(team_id: resp[:team_id])
          return render status: 400
        end

        team_from_oauth_access(resp).save
      end

      private

      def code
        params[:code]
      end

      def team_from_oauth_access(resp)
        info = SlackClient::Users.info(resp[:bot][:bot_user_id], resp[:bot][:bot_access_token])

        ::Hackbot::Team.create(
          team_id: resp[:team_id],
          team_name: resp[:team_name],
          bot_user_id: resp[:bot][:bot_user_id],
          bot_access_token: resp[:bot][:bot_access_token],
          bot_username: info[:user][:name]
        )
      end
    end
  end
end
