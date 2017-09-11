module GuggyClient
  class << self
    TRANSLATE_URL = 'http://text2gif.guggy.com/v2/guggify'

    def translate(message)
      headers = {
        'Content-Type': 'application/json',
        'apiKey': Rails.application.secrets.guggy_api_key,
      }

      body = {
        'sentence': message,
        'lang': 'en'
      }

      resp = SentryRequestClient.execute(
        method: :post,
        url: TRANSLATE_URL,
        headers: headers,
        payload: body
      )

      data = JSON.parse(resp, symbolize_names: true)

      data[:animated].first.nil? ? nil : data[:animated].first[:gif][:hires]
    end
  end
end
