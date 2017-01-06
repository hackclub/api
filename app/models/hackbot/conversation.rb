module Hackbot
  class Conversation < ApplicationRecord
    after_initialize :default_values

    belongs_to :team,
               foreign_key: 'hackbot_team_id',
               class_name: ::Hackbot::Team

    validates :team, :state, presence: true

    def self.should_start?(_event)
      raise NotImplementedError
    end

    def part_of_convo?(event)
      # Don't react to events that we cause
      event[:user] != team.bot_user_id
    end

    def handle(event)
      next_state = send(state, event)

      self.state = if next_state.is_a? Symbol
                     next_state
                   else
                     :finish
                   end

      send(:finish, event) if state == :finish
    end

    protected

    def start(_event)
      raise notImplementedError
    end

    def finish(event); end

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

    private

    def default_values
      self.state ||= :start
      self.data ||= {}
    end
  end
end
