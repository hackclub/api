# frozen_string_literal: true

class ApplicantMailer < ApplicationMailer
  def login_code(login_code)
    user = login_code.user

    @login_code = login_code.pretty

    mail(to: user.email,
         subject: "Hack Club Login Code: #{@login_code}",
         from: 'Hack Club <login@hackclub.com>',
         reply_to: 'Hack Club Team <team@hackclub.com>')
  end

  def added_to_application(application, user, adder)
    @high_school = application.high_school_name
    @user_email = user.email
    @adder_email = adder.email

    mail(to: user.email,
         subject: "You've been added to a Hack Club application")
  end

  def application_submission(application, user)
    @application = application
    @profile = LeaderProfile.find_by(new_club_application: application,
                                     user: user)

    @application_fields = application_fields(@application)
    @profile_fields = profile_fields(@profile)

    mail(to: user.email, subject: 'Hack Club Application Submitted')
  end

  def application_submission_staff(application)
    @application_fields = application_fields(application)
    @profiles_w_fields = {}

    application.leader_profiles.map do |p|
      @profiles_w_fields[p] = profile_fields(p)
    end

    @id = application.id
    school = application.high_school_name

    mail(to: 'Hack Club Team <applications@hackclub.com>',
         subject: "Application Submitted (##{@id}, #{school})")
  end

  def application_submission_json(application)
    @attributes = application.attributes
    @attributes['leader_profiles'] =
      application.leader_profiles.map(&:attributes)
    @id = application.id
    school = application.high_school_name

    mail(to: 'Hack Club Team <applications+json@hackclub.com>',
         subject: "Application JSON notification (##{@id}, #{school})")
  end

  private

  def application_fields(application)
    {
      'High School Name': application.high_school_name,
      'High School Website': application.high_school_url,
      'High School Type': application.high_school_type.humanize,
      'High School Address': application.high_school_address,

      'How long have you known your other club leaders and how did you meet?':
      application.leaders_team_origin_story,

      'Why did you decide to start a Hack Club? Have you ran anything like a '\
      'Hack Club before? Why do you think the club is going to work?' =>
      application.idea_why,

      "Has your school had coding clubs before? What's going to be new about "\
      'your Hack Club?' =>
      application.idea_other_coding_clubs,

      'What other clubs exist at your school? Why will you be just as '\
      'successful, if not more, than them?' =>
      application.idea_other_general_clubs,

      'Have you already registered your club with your school?':
      application.formation_registered,

      'Please provide any other relevant information about the structure or '\
      'formation of the club.' =>
      application.formation_misc,

      'What is something surprising or amusing you discovered?':
      application.other_surprising_or_amusing_discovery,

      'What convinced you to start a Hack Club?':
      application.curious_what_convinced,

      'How did you hear about Hack Club?':
      application.curious_how_did_hear
    }
  end

  def profile_fields(profile)
    {
      'Full Name': profile.leader_name,
      'Email': profile.leader_email,
      'Birthday': profile.leader_birthday,
      'Year in school': profile.leader_year_in_school.humanize,
      'Gender': profile.leader_gender.humanize,
      'Ethnicity': profile.leader_ethnicity.humanize,
      'Phone number': profile.leader_phone_number,
      'Mailing address': profile.leader_address,
      'Personal website': profile.presence_personal_website,
      'GitHub URL': profile.presence_github_url,
      'Twitter URL': profile.presence_twitter_url,

      'Please tell us about the time you most successfully hacked some '\
      '(non-computer) system to your advantage.' =>
      profile.skills_system_hacked,

      'Please tell us in one or two sentences about the most impressive thing '\
      'you have built or achieved.' =>
      profile.skills_impressive_achievement,

      'Are you a technical leader? (You are a programmer who can teach '\
      'without outside assistance)' =>
      (profile.skills_is_technical ? 'Yes' : 'No')
    }
  end
end
