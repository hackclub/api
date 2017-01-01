class Hackbot::Conversation < ApplicationRecord
  after_initialize :default_values

  belongs_to :team, foreign_key: 'hackbot_team_id', class_name: ::Hackbot::Team

  validates_presence_of :team, :state

  def self.should_start?(event)
    raise NotImplementedError
  end

  def is_part_of_convo?(event)
    # Don't react to events that we cause
    event[:user] != self.team.bot_user_id
  end

  def handle(event)
    next_state = send(self.state, event)

    if next_state.is_a? Symbol
      self.state = next_state
    else
      self.state = :finish
    end

    if self.state == :finish
      send(:finish, event)
    end
  end

  protected

  def start(event)
    raise notImplementedError
  end

  def finish(event)
  end

  def send_msg(channel, text)
    SlackClient::Chat.send_msg(channel, text, self.team.bot_access_token, as_user: true)
  end

  private

  def default_values
    self.state ||= :start
    self.data ||= {}
  end
end
