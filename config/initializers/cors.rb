# Be sure to restart your server when you modify this file.
#
# Avoid CORS issues when API is called from the frontend app.
#
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin
# AJAX requests.
#
# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  BASE_ORIGINS = ['https://new.hackclub.com', 'https://hackclub.com'].freeze

  allow do
    origins do |source, _env|
      allowed_origins = BASE_ORIGINS.dup
      allowed_origins << 'localhost' if Rails.env.development?

      matched = allowed_origins.select do |origin|
        # If the given source equals one of our origins, then we're good.
        next true if source == origin

        # If the given source's raw URI host equals one of our origins, then
        # we're also good.
        parsed = URI.parse(source)
        next true if parsed.host == origin
      end

      true if matched.any?
    end

    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
