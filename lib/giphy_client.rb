module GiphyClient
  class << self
    BASE_URL = 'https://api.giphy.com'.freeze
    TRANSLATE_ENDPOINT = '/v1/gifs/translate'.freeze

    def translate(message)
      headers = {
        params: {
          s: message,
          api_key: Rails.application.secrets.giphy_api_key
        }
      }

      resp = RestClient.get(BASE_URL + TRANSLATE_ENDPOINT, headers)
      data = JSON.parse(resp, symbolize_names: true)[:data]
      data.empty? ? nil : data[:images][:fixed_height]
    end
  end
end
