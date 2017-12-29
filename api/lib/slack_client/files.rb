# frozen_string_literal: true
module SlackClient
  module Files
    def self.upload(channel, filename, file, access_token)
      SlackClient.rpc(
        'files.upload',
        access_token,
        filename: filename,
        file: file,
        channels: channel
      )
    end
  end
end
