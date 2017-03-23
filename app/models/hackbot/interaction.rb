module Hackbot
  class Interaction < ApplicationRecord
    include Hackbot::Callbacks

    attr_internal :event

    after_initialize :default_values

    belongs_to :team,
               foreign_key: 'hackbot_team_id',
               class_name: ::Hackbot::Team

    validates :team, :state, presence: true

    def self.should_start?(event, team)
      new(event: event, team: team).should_start?
    end

    def should_start?
      raise NotImplementedError
    end

    def should_handle?
      # Don't react to events that we cause
      event[:user] != team.bot_user_id
    end

    def handle
      run_callbacks :handle do
        next_state = send(state)

        self.state = if next_state.is_a? Symbol
                       next_state
                     else
                       :finish
                     end

        send(:finish) if state == :finish
      end
    end

    protected

    def start
      raise NotImplementedError
    end

    def finish; end

    def msg
      return nil unless event[:type] == 'message'

      event[:text]
    end

    def action
      return nil unless event[:type] == 'action'

      event[:action]
    end

    def access_token
      team.bot_access_token
    end

    def send_msg(channel, msg)
      to_send = { as_user: true }

      if msg.is_a? String
        to_send[:text] = msg
      else
        to_send = to_send.merge(msg)
      end

      if to_send[:attachments]
        to_send[:attachments] = insert_attachment_defaults(to_send[:attachments])
      end

      ::SlackClient::Chat.send_msg(channel, nil, access_token, to_send)
    end

    def attach(channel, *attachments)
      send_msg(channel, attachments: attachments)
    end

    # Commenting because this method's name is somewhat confusing. Please rename
    # if you can think of something better.
    #
    # This method updates the message that triggered action with the passed in
    # attachments. It uses action's special response_url attribute to update the
    # source message without leaving a note in the user's Slack client saying
    # that the source message was edited, making the UX of the edit much nicer.
    #
    # The whole behavior of response_url can be quite confusing and difficult to
    # understand -- the first thing to understand is that the request format is
    # different from regular Web API calls and, therefore, can't be used with
    # our current SlackClient implementation.
    #
    # Docs: https://api.slack.com/docs/message-buttons#overview
    def update_action_source(msg)
      if msg[:attachments]
        msg[:attachments] = insert_attachment_defaults(msg[:attachments])
      end

      RestClient::Request.execute(
        method: :post,
        url: event[:response_url],
        payload: {
          token: access_token,
          **msg
        }.to_json
      )
    end

    def copy(key, hash = {}, source = default_copy_source)
      hash = hash.merge default_copy_hash

      cs = ::CopyService.new(source, hash)

      cs.get_copy key
    end

    def send_file(channel, filename, file)
      SlackClient::Files.upload(
        channel,
        filename,
        file,
        access_token
      )
    end

    def current_slack_user
      return nil unless event[:user]

      @_slack_user ||= SlackClient::Users.info(
        event[:user],
        access_token
      )[:user]
    end

    private

    def default_values
      self.state ||= :start
      self.data ||= {}
    end

    def default_copy_source
      self.class.name.demodulize.underscore
    end

    def default_copy_hash
      {
        team: team,
        event: event
      }
    end

    def insert_attachment_defaults(attachments)
      mutated = attachments.deep_dup

      mutated.each do |a|
        # Enable text formatting for all possible values by default
        #
        # Docs: https://api.slack.com/docs/message-formatting#message_formatting
        a[:mrkdwn_in] ||= %w(pretext text fields)

        insert_action_defaults!(a) if a[:actions]
      end

      mutated
    end

    def insert_action_defaults!(attachment)
      # Set callback_id to the current interaction id for attachments that
      # include actions. We don't actually use this anywhere, opting to use
      # our should_handle? method instead to figure out how to handle actions
      # (as of 2017-03-22, at least), but this is a required field for actions
      # to work so we must set it.
      attachment[:callback_id] ||= id

      attachment[:actions].each do |action|
        # Set actions to buttons by default to simplify action usage. As of
        # 2017-03-22, there aren't any other action types, but they may be
        # added in the future.
        action[:type] ||= 'button'

        # Simplify usage by setting a default name.
        action[:name] ||= 'default_name'
      end
    end
  end
end
