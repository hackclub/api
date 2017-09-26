module V1
  module SlackInvitation
    class StrategiesController < ApplicationController
      def show
        render json:  {
          id: 0,
          name: 'mason',
          club_name: 'Mason Hack Club',
          primary_color: '#d31b6b',
          greeting: "Hello welcome to Hack Club's Slack :)",
          channels: [],
          user_groups: []
        }
      end
    end
  end
end
