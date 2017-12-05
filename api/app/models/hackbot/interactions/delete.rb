module Hackbot
  module Interactions
    class Delete < TextConversation
      CHANNELS_TO_DELETE = Rails.application.secrets.channels_to_clear
                                .split(',')

      def should_start?
        event[:type] == 'message' &&
          event[:subtype].nil? &&
          CHANNELS_TO_DELETE.include?(event[:channel])
      end

      def start
        return unless admin_token

        SlackClient::Chat.delete(
          event[:channel],
          event[:ts],
          admin_token
        )
      end

      private

      def admin_token
        @admin_token ||= AdminUser.find_by(team: team.team_id)
                                  .try(:access_token)
      end
    end
  end
end
