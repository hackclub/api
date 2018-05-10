# frozen_string_literal: true

Geocoder.configure(
  # Geocoding service timeout (secs)
  timeout: 3,
  # name of geocoding service (symbol)
  lookup: :google,
  # ISO-639 language code
  language: :en,
  # use HTTPS for lookup requests? (if supported)
  use_https: true,
  # API key for geocoding service
  api_key: Rails.application.secrets.google_maps_api_key,
  units: :mi, # :km for kilometers or :mi for miles
  distances: :linear # :spherical or :linear
)
