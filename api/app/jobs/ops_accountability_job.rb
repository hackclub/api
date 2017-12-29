# frozen_string_literal: true
class OpsAccountabilityJob < ApplicationJob
  SLACK_CHANNEL = 'C0C78SG9L'.freeze

  def perform(channel = SLACK_CHANNEL)
    Hackbot::Interactions::Accountability.trigger(nil, nil, channel)
  end
end
