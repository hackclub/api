module V1
  module Home
    class SlackUsersController < ApplicationController
      def index
        @page = (params[:page] || 0).to_i
        @inc = (params[:inc] || 100).to_i
        @res = (params[:res] || 192).to_i

        render json: {
          current_page: @page,
          pages_remaining: pages_remaining,
          profile_pictures: most_active_users_profile_pictures
        }
      end

      private

      def most_active_users_profile_pictures
        most_active_users
          .map { |user| user['profile']["image_#{@res}"] }
      end

      def most_active_users
        log
          .data['stats']
          .sort_by { |entry| -entry['chats_sent'] }
          .slice(@page * @inc, (@page + 1) * @inc)
          .map { |entry| slack_user(entry['user_id']) }
      end

      def slack_user(slack_id)
        log.data['users'][slack_id]
      end

      def pages_remaining
        pages = log.data['stats'].count / @inc

        pages - @page
      end

      def log
        @log ||= SlackAnalyticLog.last
      end
    end
  end
end
