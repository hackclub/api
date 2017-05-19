module Hackbot
  module Interactions
    class Notify < Hackbot::Interactions::Command
      TRIGGER = /notify (?<message>.*)/

      USAGE = 'hackbot notify <message>'.freeze
      DESCRIPTION = 'Send a notification to an entire channel'.freeze

      def start
        message = captured[:message]
        msg_channel(
                     text: copy('start.text'),
                     attachments: [
                       fallback: copy('start.attachments.fallback'),
                       fields: [
                         { title: "Message", value: message}
                       ],
                       actions: copy('start.attachments.actions')
                     ]
        )

        data['message'] = message
        data['user'] = event['user']

        :wait_for_should_send
      end

      def wait_for_should_send
        return :wait_for_should_send unless action

        return :wait_for_should_send unless data['user'] == event[:user]

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

        recipients.each do | recipient_slack_id |
          send_msg(
            recipient_slack_id,
            text: copy('should_send.positive.dispatch', slack_id: data['user']),
            attachments: [
              color: '#e42d40',
              author_name: "@#{author[:name]}",
              author_icon: author[:profile][:image_72],
              text: data['message'],
              ts: Time.now.to_i
            ]
        )
        end
      end

      def slack_ids_of_channel(id)
        SlackClient::Channels.info(id, access_token)[:channel][:members]
      end
    end
  end
end
