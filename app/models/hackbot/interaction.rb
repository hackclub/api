module Hackbot
  class Interaction < ApplicationRecord
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
      next_state = send(state)

      self.state = if next_state.is_a? Symbol
                     next_state
                   else
                     :finish
                   end

      send(:finish) if state == :finish
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

    def copy(key, hash = {}, source = default_copy_source)
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

    private

    def default_values
      self.state ||= :start
      self.data ||= {}
    end

    def default_copy_source
      self.class.name.demodulize.underscore
    end
  end
end
