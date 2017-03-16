module SlackClient
  module Im
    def self.info(id, access_token)
      list(access_token)[:ims].find { |im| im[:id] == id }
    end

    def self.list(access_token)
      SlackClient.rpc('im.list', access_token)
    end
  end
end
