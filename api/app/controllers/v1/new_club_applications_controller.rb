# frozen_string_literal: true

module V1
  class NewClubApplicationsController < ApiController
    include ApplicantAuth

    def index
      if params[:applicant_id] == @applicant.id.to_s
        render_success(@applicant.new_club_applications)
      else
        render_access_denied
      end
    end

    def show
      application = NewClubApplication.find_by(id: params[:id])

      return render_not_found unless application

      if application.applicants.include? @applicant
        render_success(application)
      else
        render_access_denied
      end
    end

    def create
      c = NewClubApplication.create(applicants: [@applicant],
                                    point_of_contact: @applicant)

      render_success(c, 201)
    end

    def update
      c = NewClubApplication.find(params[:id])

      return render_access_denied unless c.applicants.include? @applicant

      if c.update_attributes(club_application_params)
        render_success(c)
      else
        render_field_errors(c.errors)
      end
    end

    def add_applicant
      app = NewClubApplication.find_by(id: params[:new_club_application_id])

      return render_not_found unless app
      return render_access_denied unless app.applicants.include? @applicant

      if app.submitted_at.present?
        return render_field_error(:base, 'cannot edit application after submit')
      end

      to_add = Applicant.find_or_create_by(email: params[:email])

      if app.applicants.include? to_add
        return render_field_error(:email, 'already added')
      end

      profile = ApplicantProfile.with_deleted.find_or_create_by(
        applicant: to_add,
        new_club_application: app
      )

      profile.restore if profile.deleted?

      ApplicantMailer.added_to_application(app, to_add, @applicant)
                     .deliver_later

      render_success
    end

    def remove_applicant
      app = NewClubApplication.find_by(id: params[:new_club_application_id])
      to_remove = Applicant.find_by(id: params[:applicant_id])

      return render_not_found unless app && to_remove

      return render_access_denied unless app.applicants.include? @applicant

      return render_access_denied unless app.point_of_contact == @applicant

      if app.submitted_at.present?
        return render_field_error(:base, 'cannot edit application after submit')
      end

      if to_remove == @applicant
        return render_field_error(:applicant_id, 'cannot remove self')
      end

      unless app.applicants.include? to_remove
        return render_field_error(:applicant_id, 'not added to application')
      end

      app.applicants.delete(to_remove)
      render_success
    end

    def submit
      app = NewClubApplication.find_by(id: params[:new_club_application_id])

      return render_not_found unless app
      return render_access_denied unless app.applicants.include? @applicant

      if app.submit!
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
        :point_of_contact_id
      )
    end
  end
end
