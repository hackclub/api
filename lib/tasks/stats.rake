namespace :stats do
  desc "Get a summary of our current stats"
  task summary: :environment do
    PIPELINE_KEY = Rails.application.secrets.streak_club_pipeline_key
    ACTIVE_STAGES = [
      "5001", # Onboarded
      "5003"  # Had post-first meeting check-in / active
    ]
    AVERAGE_CLUB_SIZE = 24
    ADDRESS_FIELD_KEY = Club.field_mappings[:address].to_sym

    boxes = StreakClient::Box.all_in_pipeline(PIPELINE_KEY)
    active_boxes = boxes.select { |b| ACTIVE_STAGES.include? b[:stage_key] }
    addresses = active_boxes.map { |b| b[:fields][ADDRESS_FIELD_KEY] }

    stats = {
      active_club_count: active_boxes.count,
      average_club_size: AVERAGE_CLUB_SIZE,
      total_member_count: AVERAGE_CLUB_SIZE * active_boxes.count,
      state_count: calculate_state_count(addresses),
      country_count: calculate_country_count(addresses)
    }

    stats.each do |name, stat|
      puts "#{name.to_s.humanize.titleize}: #{stat}"
    end
  end

  def calculate_state_count(addresses)
    # Does the address end with 5 numbers? i.e. does it end with a postal code?
    usa_addresses = addresses.select { |a| /\d{5}$/.match(a) }

    states = Set.new

    usa_addresses.each do |address|
      state = /.*(?<state>\w\w) \d*$/.match(address)[:state]

      states << state
    end

    states.count
  end

  def calculate_country_count(addresses)
    # Remove addresses that end in a postal code (USA addresses)
    international_addresses = addresses.select { |a| !/\d{5}$/.match(a) }

    countries = Set.new

    international_addresses.each do |address|
      country = /.*?, (?<country>[\w ]+)$/.match(address)[:country]

      countries << country
    end

    countries.count
  end
end
