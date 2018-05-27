# frozen_string_literal: true

# rubocop:disable all

desc 'Migrate Clubs/Leaders to NewClubs/NewLeaders'
task migrate_legacy_clubs: :environment do
  # disable Streakable callbacks
  Club.skip_callback(:create, :before, :create_box)
  Club.skip_callback(:update, :before, :update_box_if_changed)
  Club.skip_callback(:destroy, :before, :destroy_box)
  Leader.skip_callback(:create, :before, :create_box)
  Leader.skip_callback(:update, :before, :update_box_if_changed)
  Leader.skip_callback(:destroy, :before, :destroy_box)

  Club.find_each do |club|
    new_club = NewClub.new

    new_club.created_at = club.created_at
    new_club.updated_at = club.updated_at # this will be overridden anyways

    new_club.high_school_name = club.name

    # address
    new_club.high_school_address = club.address
    new_club.high_school_parsed_address = club.parsed_address
    new_club.high_school_parsed_city = club.parsed_city
    new_club.high_school_parsed_state = club.parsed_state
    new_club.high_school_parsed_state_code = club.parsed_state_code
    new_club.high_school_parsed_postal_code = club.parsed_postal_code
    new_club.high_school_parsed_country = club.parsed_country
    new_club.high_school_parsed_country_code = club.parsed_country_code
    new_club.high_school_latitude = club.latitude
    new_club.high_school_longitude = club.longitude

    if club.stage_key == Club::ACTIVE_STAGE
      new_club.send_check_ins = true
    elsif club.stage_key == Club::DORMANT_STAGE
      new_club.send_check_ins = false
    elsif club.stage_key == Club::DEAD_STAGE
      new_club.died_at = club.time_of_death
    elsif club.stage_key == Club::INDIA_STAGE
      # do some india-specific logic
    end

    new_club.club = club # create association to the new club

    new_club.save!

    club.leaders.each do |leader|
      new_leader = NewLeader.new

      new_leader.created_at = leader.created_at
      new_leader.updated_at = leader.updated_at

      new_leader.name = leader.name
      new_leader.email = leader.email
      new_leader.birthday = '1900-01-01'

      if leader.year
        raw_translated_year = Leader
        .field_mappings[:year][:options]
        .find { |_k, v| v == leader.year }[0]
        translated_year = raw_translated_year.to_i

        # This case happens if the year stored in Streak isn't an integer -
        # something like "Unknown", "Teacher", or "Graduated"
        new_leader.expected_graduation = if translated_year.zero?
                                           '1900-01-01'
                                         else
                                           "#{translated_year}-06-01"
                                         end
      else
        new_leader.expected_graduation = '1900-01-01'
      end

      if leader.gender == '9001'
        new_leader.gender = :male
      elsif leader.gender == '9002'
        new_leader.gender = :female
      elsif leader.gender == '9003'
        new_leader.gender = :other_gender
      end

      new_leader.phone_number = leader.phone_number.presence || '1-555-555-5555'

      new_leader.ethnicity = :unknown_ethnicity

      new_leader.github_url = 'https://github.com/' + leader.github_username.strip if leader.github_username
      new_leader.twitter_url = 'https://twitter.com/' + URI.escape(leader.twitter_username.strip) if leader.twitter_username

      # address
      new_leader.address = leader.address
      new_leader.parsed_address = leader.parsed_address
      new_leader.parsed_city = leader.parsed_city
      new_leader.parsed_state = leader.parsed_state
      new_leader.parsed_state_code = leader.parsed_state_code
      new_leader.parsed_postal_code = leader.parsed_postal_code
      new_leader.parsed_country = leader.parsed_country
      new_leader.parsed_country_code = leader.parsed_country_code
      new_leader.latitude = leader.latitude
      new_leader.longitude = leader.longitude

      new_leader.leader = leader
      new_leader.user = User.find_or_initialize_by(email: leader.email.downcase)

      new_leader.save!

      new_club.new_leaders << new_leader

      # active or indian active
      #
      # delete the leadership position we just created unless they're currently
      # active leaders
      next if leader.stage_key == '5006' || leader.stage_key == '5008'
      LeadershipPosition.find_by(
        new_club: new_club,
        new_leader: new_leader
      ).destroy
    end
  end
end

# rubocop:enable all