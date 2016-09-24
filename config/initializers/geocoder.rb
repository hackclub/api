Geocoder.configure(
  # Geocoding options
  timeout: 3,                 # geocoding service timeout (secs)
  lookup: :google,            # name of geocoding service (symbol)
  language: :en,              # ISO-639 language code
  use_https: true,            # use HTTPS for lookup requests? (if supported)
  api_key: Rails.application.secrets.google_maps_api_key, # API key for geocoding service

  # Calculation options
  units: :mi,                 # :km for kilometers or :mi for miles
  distances: :linear          # :spherical or :linear
)
