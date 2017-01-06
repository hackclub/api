module SlackClient
  module Chat
    def self.open_im(user_id, access_token)
      SlackClient.rpc('im.open', access_token, user: user_id, return_im: true)
    end

    def self.send_msg(channel, text, access_token, extra_params = {})
      extra_params[:channel] ||= channel
      extra_params[:text] ||= text

      SlackClient.rpc('chat.postMessage', access_token, extra_params)
    end
  end
end
