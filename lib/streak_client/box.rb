module StreakClient
  module Box
    def self.all_in_pipeline(pipeline_key)
      StreakClient.request(:get, "/v1/pipelines/#{pipeline_key}/boxes")
    end

    def self.create_in_pipeline(pipeline_key, name)
      StreakClient.request(:put, "/v1/pipelines/#{pipeline_key}/boxes", { name: name })
    end

    # params is a hash of key value pairs for fields to update in Streak.
    #
    # Accepted keys: :name, :notes, :stageKey, :followerKeys, and :linkedBoxKeys
    #
    # :names and :notes are strings. :stageKey is the key of the stage to change
    # the box to. :followerKeys and :linkedBoxKeys are both arrays of strings
    # representing keys on Streak.
    #
    # See https://www.streak.com/api/#editbox
    def self.update(box_key, params)
      StreakClient.request(:post, "/v1/boxes/#{box_key}", params)
    end

    # See https://www.streak.com/api/#editFieldBox
    def self.edit_field(box_key, field_key, value)
      StreakClient.request(
        :post,
        "/v1/boxes/#{box_key}/fields/#{field_key}",
        {
          value: value
        }
      )
    end

    # https://www.streak.com/api/#deletebox
    def self.delete(box_key)
      StreakClient.request(
        :delete,
        "/v1/boxes/#{box_key}"
      )
    end
  end
end
