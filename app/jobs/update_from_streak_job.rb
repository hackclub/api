class UpdateFromStreakJob < ApplicationJob
  queue_as :default

  CLUB_PIPELINE = Rails.application.secrets.streak_club_pipeline_key
  LEADER_PIPELINE = Rails.application.secrets.streak_leader_pipeline_key

  def perform(*args)
    club_pipeline = StreakClient::Pipeline.find(CLUB_PIPELINE)
    leader_pipeline = StreakClient::Pipeline.find(LEADER_PIPELINE)

    club_boxes = StreakClient::Box.all_in_pipeline(CLUB_PIPELINE)
    leader_boxes = StreakClient::Box.all_in_pipeline(LEADER_PIPELINE)

    # Create and update clubs
    club_boxes.each do |box|
      club = Club.find_or_initialize_by(streak_key: box[:key])

      club.update_attributes(
        name: box[:name],
        address: box[:fields][:"1006"],
        latitude: box[:fields][:"1007"],
        longitude: box[:fields][:"1008"]
      )

      # Delete old relationships
      club.leaders.each do |leader|
        unless box[:linked_box_keys].include? leader.streak_key
          leader.destroy!
        end
      end
    end

    # Delete clubs that are no longer present
    Club.find_each do |c|
      exists_in_streak = false

      club_boxes.each do |box|
        if c.streak_key == box[:key]
          exists_in_streak = true
        end
      end

      c.destroy! unless exists_in_streak
    end

    leader_boxes.each do |box|
      gender_field_key = "1001"
      year_field_key = "1002"

      leader = Leader.find_or_initialize_by(streak_key: box[:key])

      leader.update_attributes(
        name: box[:name],
        streak_key: box[:key],
        gender: dropdown_value(
          leader_pipeline,
          gender_field_key,
          box[:fields][gender_field_key.to_sym]
        ),
        year: dropdown_value(
          leader_pipeline,
          year_field_key,
          box[:fields][year_field_key.to_sym]
        ),
        email: box[:fields][:"1003"],
        phone_number: box[:fields][:"1010"],
        slack_username: box[:fields][:"1006"],
        github_username: box[:fields][:"1009"],
        twitter_username: box[:fields][:"1008"],
        address: box[:fields][:"1011"],
        latitude: box[:fields][:"1018"],
        longitude: box[:fields][:"1019"]
      )

      box[:linked_box_keys].each do |linked_box_key|
        c = Club.find_by(streak_key: linked_box_key)
        unless c.nil? or c.leaders.include? leader
          c.leaders << leader
        end
      end
    end

    # Delete leaders that are no longer present
    Leader.find_each do |l|
      exists_in_streak = false

      leader_boxes.each do |box|
        if l.streak_key == box[:key]
          exists_in_streak = true
        end
      end

      l.destroy! unless exists_in_streak
    end
  end

  private

  def dropdown_value(pipeline, field_key, dropdown_value_key)
    field_spec = pipeline[:fields].find { |f| f[:key] == field_key }
    dropdown_items = field_spec[:dropdown_settings][:items]

    item = dropdown_items.find { |item| item[:key] == dropdown_value_key }

    item[:name]
  end
end
