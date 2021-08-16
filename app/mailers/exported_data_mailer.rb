class ExportedDataMailer < ApplicationMailer
  def notify_leader
    @leader_profile = LeaderProfile.find params[:leader_profile_id]
    @application = LeaderProfile.new_club_application

    mail(
      to: @leader_profile.leader_email || @leader_profile.user.email,
      subject: "[Data export] Unsubmitted Hack Club application",
      from: "Hack Club <applications@hackclub.com>"
    )
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