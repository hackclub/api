# frozen_string_literal: true

Bugsnag.configure do |config|
  config.api_key = Rails.application.secrets.bugsnag_api_key
end
