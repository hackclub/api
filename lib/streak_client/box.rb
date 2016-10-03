module StreakClient
  module Box
    def self.all_in_pipeline(pipeline_key)
      StreakClient.request(:get, "/v1/pipelines/#{pipeline_key}/boxes")
    end
  end
end
