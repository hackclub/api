module StreakClient
  module Box
    def self.all
      StreakClient.request(:get, '/v1/boxes')
    end

    def self.all_in_pipeline(pipeline_key)
      results = []
      page = 0
      more_results = true

      while more_results
        resp = all_in_pipeline_paginated(pipeline_key, page: page, limit: 50)
        results += resp[:results]
        more_results = resp[:has_next_page]

        page += 1
      end

      results
    end

    def self.all_in_pipeline_paginated(pipeline_key, page:, limit:)
      StreakClient.request(
        :get,
        "/v2/pipelines/#{pipeline_key}/boxes",
        page: page,
        limit: limit
      )
    end

    def self.create_in_pipeline(pipeline_key, name)
      StreakClient.request(
        :put,
        "/v1/pipelines/#{pipeline_key}/boxes",
        name: name
      )
    end

    # params is a hash of key value pairs for fields to update in Streak.
    #
    # Accepted keys: :name, :notes, :stage_key, :follower_keys, and
    # :linked_box_keys
    #
    # :names and :notes are strings. :stage_key is the key of the stage to
    # change the box to. :follower_keys and :linked_box_keys are both arrays of
    # strings representing keys on Streak.
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
        value: value
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
