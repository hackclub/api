# frozen_string_literal: true

module Hackbot
  class Interaction < ApplicationRecord
    include Hackbot::Callbacks
    include Hackbot::Copy
    include Hackbot::Helpers
    include Hackbot::SlackInteraction

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

    private

    def default_values
      self.state ||= :start
      self.data ||= {}
    end
  end
end
