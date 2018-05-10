# frozen_string_literal: true

class RemoveVideoUrlFromNewClubApplications < ActiveRecord::Migration[5.1]
  class NewClubApplications < ActiveRecord::Base; end

  def up
    NewClubApplications.find_each do |app|
      if app.leaders_video_url
        app.legacy_fields ||= {}
        app.legacy_fields['Video URL'] = app.leaders_video_url
        app.save
      end
    end

    remove_column :new_club_applications, :leaders_video_url
  end

  def down
    add_column :new_club_applications, :leaders_video_url, :text

    NewClubApplications.find_each do |app|
      app.legacy_fields ||= {}

      video = app.legacy_fields['Video URL']

      if video
        app.leaders_video_url = video
        app.legacy_fields.delete('Video URL')
        app.save
      end
    end
  end
end
