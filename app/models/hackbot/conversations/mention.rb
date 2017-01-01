class Hackbot::Conversations::Mention < Hackbot::Conversations::Channel
  def self.should_start?(event)
    event[:type] == 'message' && event[:text] =~ /hackbot/
  end

  def start(event)
    msg_channel "Did someone mention me?"

    :wait_for_resp
  end

  def wait_for_resp(event)
    if event[:text] =~ /^(no|nope|nah|negative)$/i
      msg_channel "Oh, I see... :slightly_frowning_face:"
    elsif event[:text] =~ /^(yes|yeah|yah|ya|yup)$/i
      msg_channel "Oh my! I'm so glad to hear... I was getting a little worried for a moment there."
    end

    :finish
  end
end
