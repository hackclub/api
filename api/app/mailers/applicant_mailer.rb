# frozen_string_literal: true
class ApplicantMailer < ApplicationMailer
  def login_code(applicant)
    @login_code = applicant.pretty_login_code

    mail(to: applicant.email, subject: "Hack Club Login Code (#{@login_code})")
  end

  def added_to_application(application, applicant, adder)
    @high_school = application.high_school_name
    @applicant_email = applicant.email
    @adder_email = adder.email

    mail(to: applicant.email,
         subject: "You've been added to a Hack Club application")
  end

  def application_submission(application, applicant)
    @application = application
    @profile = ApplicantProfile.find_by(new_club_application: application,
                                        applicant: applicant)

    @application_fields = {
      'High School Name': @application.high_school_name,
      'High School Website': @application.high_school_url,
      'High School Type': @application.high_school_type.humanize,
      'High School Address': @application.high_school_address,
      'Video URL': @application.leaders_video_url,

      'Please tell us about an interesting project, preferably outside of '\
      'class, that two or more of you created together. Include URLs if '\
      'possible.' =>
      @application.leaders_interesting_project,

      'How long have you known your other club leaders and how did you meet?':
      @application.leaders_team_origin_story,

      'How far along are you in starting your club?':
      @application.progress_general,

      'Have you already polled for interest at your school? Are students '\
      "interested? If you've already had meetings, how many people came?" =>
      @application.progress_student_interest,

      'Have you begun meeting yet? We encourage you to not begin meeting '\
      'until we accept you.' =>
      @application.progress_meeting_yet,

      'Why did you decide to start a Hack Club? Have you ran anything like a '\
      'Hack Club before? Why do you think the club is going to work?' =>
      @application.idea_why,

      "Has your school had coding clubs before? What's going to be new about "\
      'your Hack Club?' =>
      @application.idea_other_coding_clubs,

      'What other clubs exist at your school? Why will you be just as '\
      'successful, if not more, than them?' =>
      @application.idea_other_general_clubs,

      'Have you already registered your club with your school?':
      @application.formation_registered,

      'Please provide any other relevant information about the structure or '\
      'formation of the club.' =>
      @application.formation_misc,

      'What is something surprising or amusing you discovered?':
      @application.other_surprising_or_amusing_discovery,

      'What convinced you to start a Hack Club?':
      @application.curious_what_convinced,

      'How did you hear about Hack Club?':
      @application.curious_how_did_hear
    }

    @profile_fields = {
      'Full Name': @profile.leader_name,
      'Email': @profile.leader_email,
      'Birthday': @profile.leader_birthday,
      'Year in school': @profile.leader_year_in_school.humanize,
      'Gender': @profile.leader_gender.humanize,
      'Ethnicity': @profile.leader_ethnicity.humanize,
      'Phone number': @profile.leader_phone_number,
      'Mailing address': @profile.leader_address,
      'Personal website': @profile.presence_personal_website,
      'GitHub URL': @profile.presence_github_url,
      'LinkedIn URL': @profile.presence_linkedin_url,
      'Facebook URL': @profile.presence_facebook_url,
      'Twitter URL': @profile.presence_twitter_url,

      'Please tell us about the time you most successfully hacked some '\
      '(non-computer) system to your advanced.' =>
      @profile.skills_system_hacked,

      'Please tell us in one or two sentences about the most impressive thing '\
      'you have built or achieved.' =>
      @profile.skills_impressive_achievement,

      'Are you a technical leader? (You are a programmer who can teach '\
      'without outside assistance)' =>
      (@profile.skills_is_technical ? 'Yes' : 'No')
    }

    mail(to: applicant.email, subject: 'Hack Club Application Submitted')
  end
end
