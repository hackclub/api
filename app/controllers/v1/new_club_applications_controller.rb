# frozen_string_literal: true

module V1
  class NewClubApplicationsController < ApiController
    include UserAuth

    # All applications
    def full_index
      return render_access_denied unless @user.admin?

      apps = if params[:submitted]
               NewClubApplication.submitted.all
             else
               NewClubApplication.all
             end

      render_success apps.includes(leader_profiles: [:user])
    end

    # Applications for a specific user
    def index
      if params[:user_id] == @user.id.to_s
        apps = @user.new_club_applications.includes(leader_profiles: [:user])
        render_success apps
      else
        render_access_denied
      end
    end

    def show
      application = NewClubApplication.find(params[:id])
      authorize application

      render_success(application)
    end

    def create
      c = NewClubApplication.create(users: [@user], point_of_contact: @user)

      render_success(c, 201)
    end

    def update
      c = NewClubApplication.find(params[:id])
      authorize c

      if c.submitted? && !current_user.admin?
        return render_field_error(:base, 'cannot edit application after submit')
      end

      if club_application_params.include?('test') && !current_user.admin?
        return render_field_error(:test, 'cannot change unless admin')
      end

      if c.update_attributes(club_application_params)
        render_success(c)
      else
        render_field_errors(c.errors)
      end
    end

    def add_user
      app = NewClubApplication.find(params[:new_club_application_id])
      authorize app

      if app.submitted?
        return render_field_error(:base, 'cannot edit application after submit')
      end

      to_add = User.find_or_create_by(email: params[:email])

      if app.users.include? to_add
        return render_field_error(:email, 'already added')
      end

      profile = LeaderProfile.with_deleted.find_or_create_by(
        user: to_add,
        new_club_application: app
      )

      profile.restore if profile.deleted?

      ApplicantMailer.added_to_application(app, to_add, @user)
                     .deliver_later

      render_success
    end

    def remove_user
      app = NewClubApplication.find(params[:new_club_application_id])
      to_remove = User.find(params[:user_id])

      authorize app

      if app.submitted?
        return render_field_error(:base, 'cannot edit application after submit')
      end

      if to_remove == @user
        return render_field_error(:user_id, 'cannot remove self')
      end

      unless app.users.include? to_remove
        return render_field_error(:user_id, 'not added to application')
      end

      app.users.delete(to_remove)
      render_success
    end

    def submit
      app = NewClubApplication.find(params[:new_club_application_id])
      authorize app

      if app.submit!
        render_success(app)
      else
        render_field_errors(app.errors)
      end
    end

    def unsubmit
      app = NewClubApplication.find(params[:new_club_application_id])
      authorize app

      unless app.submitted?
        return render_field_error(:base, 'application not submitted')
      end

      # give descriptive error, it will fail without this check anyways - just
      # not with a very good error message
      if app.interviewed?
        return render_field_error(:base, 'cannot unsubmit after interview')
      end

      app.submitted_at = nil

      if app.save
        render_success app
      else
        render_field_errors app.errors
      end
    end

    def accept
      app = NewClubApplication.find(params[:new_club_application_id])
      authorize app

      if app.accept! && app.save
        render_success(app)
      else
        render_field_errors(app.errors)
      end
    end

    private

    def club_application_params
      params.permit(
        :high_school_name,
        :high_school_url,
        :high_school_type,
        :high_school_address,
        :leaders_team_origin_story,
        :progress_general,
        :progress_student_interest,
        :progress_meeting_yet,
        :idea_why,
        :idea_other_coding_clubs,
        :idea_other_general_clubs,
        :formation_registered,
        :formation_misc,
        :other_surprising_or_amusing_discovery,
        :curious_what_convinced,
        :curious_how_did_hear,
        :point_of_contact_id,
        :interviewed_at,
        :interview_duration,
        :interview_notes,
        :rejected_at,
        :rejected_reason,
        :rejected_notes,
        :test
      )
    end
  end
end
