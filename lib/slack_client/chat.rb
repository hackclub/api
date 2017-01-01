module SlackClient
  module Chat
    def self.send_msg(channel, text, access_token, extra_params={})
      extra_params[:channel] ||= channel
      extra_params[:text] ||= text

      SlackClient.rpc('chat.postMessage', access_token, extra_params)
    end
  end
end
