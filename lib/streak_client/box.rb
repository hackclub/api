module StreakClient
  module Box
    def self.all_in_pipeline(pipeline_key)
      StreakClient.request(:get, "/v1/pipelines/#{pipeline_key}/boxes")
    end

    def self.create_in_pipeline(pipeline_key, name)
      StreakClient.request(:put, "/v1/pipelines/#{pipeline_key}/boxes", { name: name })
    end
  end
end
