module Hackbot
  module Interactions
    module Concerns
      # rubocop:disable Metrics/ModuleLength
      module Mirrorable
        extend ActiveSupport::Concern

        MIRROR_CHANNEL = Rails.application.secrets.hackbot_mirror_channel_id

        included do
          before_handle :mirror_incoming_msg

          alias_method :_send_msg, :send_msg
          alias_method :_attach, :attach
          alias_method :_send_file, :send_file

          define_method :send_msg do |channel, text|
            resp = _send_msg(channel, text)
            msg = resp[:message]

            mirror_msg(bot_slack_user, channel, msg[:ts], text)

            resp
          end

          define_method :attach do |channel, *attachments|
            resp = _attach(channel, *attachments)
            msg = resp[:message]

            mirror_attachments(bot_slack_user, channel, msg[:ts], attachments)

            resp
          end

          define_method :send_file do |channel, filename, file|
            resp = _send_file(channel, filename, file)
            file = resp[:file]

            mirror_file(bot_slack_user, channel, file[:timestamp], filename)

            resp
          end
        end

        private

        def mirror_incoming_msg
          return unless msg

          mirror_msg(current_slack_user, event[:channel], event[:ts], msg)
        end

        def mirror_msg(slack_user, channel, timestamp, text)
          _attach(
            MIRROR_CHANNEL,
            text: text,
            fallback: mirror_copy(
              'mirror_msg.fallback',
              slack_mention: mention_for(slack_user),
              text: text
            ),
            **attachment_template(slack_user, channel, timestamp)
          )
        end

        def mirror_attachments(slack_user, channel, timestamp, attachments)
          # Make all of the attachments the same color when sending
          attachments.each { |a| a[:color] = color_for(slack_user) }

          _attach(
            MIRROR_CHANNEL,
            {
              fallback: mirror_copy('mirror_attachments.fallback',
                                    slack_mention: mention_for(slack_user)),
              **attachment_template(slack_user, channel, timestamp)
            },
            *attachments
          )
        end

        def mirror_file(slack_user, channel, timestamp, filename)
          _attach(
            MIRROR_CHANNEL,
            text: mirror_copy('mirror_file.text', filename: filename),
            fallback: mirror_copy(
              'mirror_file.fallback',
              slack_mention: mention_for(slack_user),
              filename: filename
            ),
            **attachment_template(slack_user, channel, timestamp)
          )
        end

        def attachment_template(slack_user, channel, timestamp)
          {
            color: color_for(slack_user),
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

        def color_for(slack_user)
          color_hex_from_string(slack_user[:id])
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
