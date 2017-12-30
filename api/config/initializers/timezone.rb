# frozen_string_literal: true
Timezone::Lookup.config(:google) do |c|
  c.api_key = Rails.application.secrets.google_maps_api_key
end
