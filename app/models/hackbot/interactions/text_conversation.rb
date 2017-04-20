# TextConversation is an interaction that only consists of messages and is
# limited to a single channel on Slack.
module Hackbot
  module Interactions
    class TextConversation < Hackbot::Interaction
      include Concerns::Mirrorable

      def should_start?
        event[:type] == 'message'
      end

      def should_handle?
        (new_msg? || action) &&
          event[:channel] == data['channel'] &&
          super
      end

      def handle
        data['channel'] = event[:channel]
        super
      end

      protected

      def msg_channel(msg)
        send_msg(data['channel'], msg)
      end

      def attach_channel(*attachments)
        attach(data['channel'], *attachments)
      end

      def file_to_channel(filename, file)
        send_file(data['channel'], filename, file)
      end

      def slack_id
        if event
          event[:user]
        elsif data['channel']
          # Using the data['channel'] field we can figure out the SlackID of a
          # user if the conversation takes place in a PM
          dm_channel = channels.find { |im| im[:id] == data['channel'] }
          dm_channel ? dm_channel[:user] : nil
        end
      end

      private

      def channels
        key = "im.list##{team.id}"
        Rails.cache.fetch(key, expires_in: 2.minutes) do
          SlackClient.rpc('im.list', team.bot_access_token)[:ims]
        end
      end

      # Returns whether the current event is a new message. This prevents
      # interactions from being triggered on message edits or other subtypes of
      # messages.
      def new_msg?
        msg && !event[:subtype]
      end
    end
  end
end
