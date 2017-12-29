module Hackbot
  module Interactions
    class Notify < Hackbot::Interactions::Command
      TRIGGER = /notify (?<message>.*)/

      USAGE = 'notify <message>'.freeze
      DESCRIPTION = 'Send a notification to an entire channel'.freeze

      def start
        message = captured[:message]
        msg_channel copy('start', message: message)

        data['message'] = message
        data['user'] = event['user']

        :wait_for_should_send
      end

      def wait_for_should_send
        return :wait_for_should_send unless action &&
                                            data['user'] == event[:user]

        case action[:value]
        when Hackbot::Utterances.yes
          send_action_result copy('should_send.positive.action_result')

          dispatch_messages(slack_ids_of_channel(data['channel']))

          msg_channel copy('should_send.positive.done')
        when Hackbot::Utterances.no
          send_action_result copy('should_send.negative.action_result')

          msg_channel copy('should_send.negative.done')
        else
          :wait_for_should_send
        end
      end

      private

      def dispatch_messages(recipients)
        author = SlackClient::Users.info(data['user'], access_token)[:user]

        recipients.each do |recipient_slack_id|
          notify(author, recipient_slack_id, data['message'])
        end
      end

      def notify(from, to, message)
        send_msg(
          to,
          text: copy('should_send.positive.dispatch', slack_id: from[:id]),
          attachments: [
            color: '#e42d40',
            from_name: "@#{from[:name]}",
            from_icon: from[:profile][:image_72],
            text: message,
            ts: Time.now.to_i
          ]
        )
      end

      def slack_ids_of_channel(id)
        SlackClient::Channels.info(id, access_token)[:channel][:members]
      end
    end
  end
end
