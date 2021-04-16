# frozen_string_literal: true

class RemoveLeadersProjectFromNewClubApplications < ActiveRecord::Migration[5.1]
  class NewClubApplications < ActiveRecord::Base; end

  QUESTION = 'Please tell us about an interesting project, preferably outside '\
    'of class, that two or more of you created together. Include URLs if '\
    'possible.'

  def up
    NewClubApplications.all.each do |app|
      if app.leaders_interesting_project
        app.legacy_fields ||= {}
        app.legacy_fields[QUESTION] = app.leaders_interesting_project
        app.save!
      end
    end

    remove_column :new_club_applications, :leaders_interesting_project
  end

  def down
    add_column :new_club_applications, :leaders_interesting_project, :text

    NewClubApplications.find_each do |app|
      app.legacy_fields ||= {}

      interesting_project = app.legacy_fields[QUESTION]

      if interesting_project
        app.leaders_interesting_project = interesting_project
        app.legacy_fields.delete(QUESTION)
        app.save
      end
    end
  end
end
