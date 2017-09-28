module SlackClient
  module Chat
    def self.open_im(user_id, access_token)
      SlackClient.rpc('im.open', access_token, user: user_id, return_im: true)
    end

    def self.send_msg(channel, text, access_token, extra_params = {})
      extra_params[:channel] ||= channel
      extra_params[:text] ||= text

      # Encode attachments as JSON if we have them, as required by the API.
      if extra_params[:attachments]
        extra_params[:attachments] = extra_params[:attachments].to_json
      end

      SlackClient.rpc('chat.postMessage', access_token, extra_params)
    end

    def self.delete(channel, ts, access_token)
      SlackClient.rpc('chat.delete', access_token, channel: channel, ts: ts)
    end
  end
end
