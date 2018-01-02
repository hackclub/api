# frozen_string_literal: true

module Hackbot
  module Interactions
    module Concerns
      # rubocop:disable Metrics/ModuleLength
      module Mirrorable
        extend ActiveSupport::Concern

        MIRROR_CHANNEL = Rails.application.secrets.hackbot_mirror_channel_id

        included do
          before_handle :mirror_incoming_event

          alias_method :_send_msg, :send_msg
          alias_method :_send_file, :send_file
          alias_method :_update_action_source, :update_action_source

          define_method :send_msg do |channel, msg|
            resp = _send_msg(channel, msg)
            msg = resp[:message]

            mirror_msg(bot_slack_user, channel, msg[:ts], msg)

            resp
          end

          define_method :send_file do |channel, filename, file|
            resp = _send_file(channel, filename, file)
            file = resp[:file]

            mirror_file(bot_slack_user, channel, file[:timestamp], filename)

            resp
          end

          define_method :update_action_source do |msg, action_event = event|
            resp = _update_action_source(msg)
            timestamp = Time.now.to_i

            mirror_action_source_update(bot_slack_user, action_event[:channel],
                                        timestamp, action_event[:msg], msg)

            resp
          end
        end

        private

        def mirror_incoming_event
          channel = event[:channel]
          ts = event[:ts]

          if msg
            mirror_msg(current_slack_user, channel, ts, event)
          elsif action
            mirror_action(current_slack_user, channel, ts, action[:text])
          end
        end

        def mirror_msg(slack_user, channel, timestamp, msg_event)
          if msg_event[:attachments]&.any?
            mirror_rich_msg(slack_user, channel, timestamp, msg_event)
          else
            mirror_plain_msg(slack_user, channel, timestamp, msg_event)
          end
        end

        # Mirror a plain text message
        def mirror_plain_msg(slack_user, channel, timestamp, msg_event)
          attachments = [
            text: msg_event[:text],
            fallback: mirror_copy(
              'mirror_plain.fallback',
              slack_mention: mention_for(slack_user),
              text: msg_event[:text]
            ),
            **attachment_template(slack_user, channel, timestamp)
          ]

          _send_msg(MIRROR_CHANNEL, attachments: attachments)
        end

        # Mirror a message that includes more than just text
        def mirror_rich_msg(slack_user, channel, timestamp, msg_event)
          fallback = mirror_copy('mirror_rich.fallback',
                                 slack_mention: mention_for(slack_user))

          attachments = [
            { **attachment_template(slack_user, channel, timestamp),
              fallback: fallback },

            *rich_msg_to_attachments(msg_event)
          ]

          _send_msg(MIRROR_CHANNEL, attachments: attachments)
        end

        def mirror_file(slack_user, channel, timestamp, filename)
          copy_params = { filename: filename,
                          slack_mention: mention_for(slack_user) }

          _send_msg(
            MIRROR_CHANNEL,
            attachments: [
              text: mirror_copy('mirror_file.text', copy_params),
              fallback: mirror_copy('mirror_file.fallback', copy_params),
              **attachment_template(slack_user, channel, timestamp)
            ]
          )
        end

        def mirror_action(slack_user, channel, timestamp, action_text)
          copy_params = { action_text: action_text,
                          slack_mention: mention_for(slack_user) }

          _send_msg(
            MIRROR_CHANNEL,
            attachments: [
              text: mirror_copy('mirror_action.text', copy_params),
              fallback: mirror_copy('mirror_action.fallback', copy_params),
              **attachment_template(slack_user, channel, timestamp)
            ]
          )
        end

        def mirror_action_source_update(slack_user, channel, timestamp, old_msg,
                                        new_msg)
          _send_msg(
            MIRROR_CHANNEL,
            attachments: action_update_attachments(
              slack_user, channel, timestamp, old_msg, new_msg
            )
          )
        end

        def action_update_attachments(slack_user, channel, timestamp, old_msg,
                                      new_msg)
          [
            { fallback: mirror_copy('mirror_action_source_update.fallback'),
              **attachment_template(slack_user, channel, timestamp) },

            { text: mirror_copy('mirror_action_source_update.old_msg_pre'),
              color: attachment_color },

            *rich_msg_to_attachments(old_msg),

            { text: mirror_copy('mirror_action_source_update.new_msg_pre'),
              color: attachment_color },

            *rich_msg_to_attachments(new_msg)
          ]
        end

        def rich_msg_to_attachments(msg_event)
          attachments = []

          attachments << { text: msg_event[:text] } if msg_event[:text].present?
          attachments += msg_event[:attachments] if msg_event[:attachments]

          attachments.each { |a| a[:color] = attachment_color }

          attachments
        end

        def attachment_template(slack_user, channel, timestamp)
          {
            color: attachment_color,
            author_name: mention_for(slack_user),
            author_icon: slack_user[:profile][:image_72],
            footer: mirror_copy('template.footer',
                                source: source_for_channel(channel),
                                interaction: self.class,
                                id: id),
            ts: timestamp
          }
        end

        def bot_slack_user
          @_bot_slack_user ||= SlackClient::Users.info(
            team.bot_user_id,
            access_token
          )[:user]
        end

        def mention_for(slack_user)
          '@' + slack_user[:name]
        end

        def attachment_color
          color_hex_from_string(id.to_s)
        end

        def color_hex_from_string(str)
          Digest::MD5.hexdigest(str)[0, 6]
        end

        # Channel types are categorized by the first character in their ID.
        #
        # Here's the mapping for first characters:
        #
        #   C -> public channel
        #   G -> private channel or multiparty IM
        #   D -> direct message
        def source_for_channel(channel_id)
          case channel_id
          when /^C/ then source_for_public_channel(channel_id)
          when /^G/ then source_for_private_channel_or_mpim(channel_id)
          when /^D/ then source_for_dm(channel_id)
          else mirror_copy('template.source.unknown')
          end
        end

        def source_for_public_channel(channel_id)
          channel = SlackClient::Channels.info(channel_id,
                                               access_token)[:channel]

          mirror_copy('template.source.public_channel',
                      channel_name: channel[:name])
        end

        def source_for_private_channel_or_mpim(channel_id)
          group = SlackClient::Groups.info(channel_id, access_token)[:group]

          if group[:is_mpim]
            source_for_mpim(channel_id)
          else
            source_for_private_channel(channel_id)
          end
        end

        def source_for_private_channel(channel_id)
          group = SlackClient::Groups.info(channel_id, access_token)[:group]

          mirror_copy('template.source.private_channel',
                      channel_name: group[:name])
        end

        def source_for_mpim(mpim_id)
          mpim = SlackClient::Mpim.info(mpim_id, access_token)
          mentions = mpim[:members].map do |m|
            mention_for(SlackClient::Users.info(m, access_token)[:user])
          end

          mirror_copy('template.source.mpim', slack_mentions: mentions)
        end

        def source_for_dm(im_id)
          im = SlackClient::Im.info(im_id, access_token)
          user = SlackClient::Users.info(im[:user], access_token)[:user]

          mirror_copy('template.source.dm', slack_mention: mention_for(user))
        end

        def mirror_copy(key, hash = {})
          copy(key, hash, 'concerns/mirrorable')
        end
      end
      # rubocop:enable Metrics/ModuleLength
    end
  end
end
