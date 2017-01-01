# Channel is a conversation that is limited to a single channel on Slack. Most
# conversations will inherit from this class.
class Hackbot::Conversations::Channel < Hackbot::Conversation
  def is_part_of_convo?(event)
    event[:channel] == self.data['channel'] && super
  end

  def handle(event)
    self.data['channel'] = event[:channel]
    super
  end

  protected

  def msg_channel(text)
    send_msg(self.data['channel'], text)
  end
end
