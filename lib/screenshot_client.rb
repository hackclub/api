# frozen_string_literal: true

module ScreenshotClient
  class << self
    API_URL = 'http://api.screenshotlayer.com/api/capture'
    API_KEY = Rails.application.secrets.screenshotlayer_api_key

    def capture(url, viewport: '1440x900', width: nil, format: 'JPG')
      unless %w[PNG JPG GIF].include? format
        raise ArgumentError, 'format must be one of PNG, JPG, GIF'
      end

      params = {
        url: url,
        viewport: viewport,
        width: width,
        format: format,
        access_key: API_KEY
      }

      resp = RestClient::Request.execute(
        method: :get,
        url: API_URL + '?' + params.to_query
      )

      StringIO.new(resp.body)
    end
  end
end
