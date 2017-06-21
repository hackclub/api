module StreakClient
  module Pipeline
    def self.all
      StreakClient.request(:get, '/v1/pipelines')
    end

    def self.find(key)
      StreakClient.request(:get, "/v1/pipelines/#{key}")
    end
  end
end
