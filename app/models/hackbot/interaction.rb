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

    def access_token
      team.bot_access_token
    end

    def send_msg(channel, text)
      ::SlackClient::Chat.send_msg(
        channel,
        text,
        access_token,
        as_user: true
      )
    end

    def attach(channel, *attachments)
      # Enable text formatting for all possible values by default
      #
      # Docs: https://api.slack.com/docs/message-formatting#message_formatting
      attachments.each do |a|
        a[:mrkdwn_in] ||= %w(pretext text fields)
      end

      ::SlackClient::Chat.send_msg(
        channel,
        nil,
        access_token,
        attachments: attachments.to_json,
        as_user: true
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
  end
end
