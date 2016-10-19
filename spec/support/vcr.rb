VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.configure_rspec_metadata!

  # Allow code coverage report to be sent to Code Climate
  c.ignore_hosts "codeclimate.com"

  # Filter out everything in config/secrets.yml
  Rails.application.secrets.each do |k, v|
    c.filter_sensitive_data("ENV-#{k}") { v }
  end

  # Filter out Streak's API key
  c.filter_sensitive_data("<STREAK_API_KEY>") do
    Base64.strict_encode64(Rails.application.secrets.streak_api_key + ":")
  end

  # Filter out Cloud9 access tokens
  c.filter_sensitive_data("<CLOUD9_ACCESS_TOKEN>") do |interaction|
    url_params = Rack::Utils.parse_query(URI(interaction.request.uri).query)

    url_params["access_token"]
  end
end
