# frozen_string_literal: true
class CheckInRecord
  attr_accessor :created_at, :check_in_creator_name, :meeting_date, :club_name,
                :leader_names, :attendance, :notes

  def initialize(created_at, check_in_creator_name, meeting_date, club_name,
                 leader_names, attendance, notes)
    @created_at = created_at
    @check_in_creator_name = check_in_creator_name
    @meeting_date = meeting_date
    @club_name = club_name
    @leader_names = leader_names
    @attendance = attendance
    @notes = notes
  end

  def self.csv_title
    ['Check In Completion Timestamp', 'Check In Creator', 'Meeting Date',
     'Club Name', 'Leaders', 'Attendance', 'Notes']
  end

  def csv_contents
    [created_at, check_in_creator_name, meeting_date, club_name,
     leader_names.join(', '), attendance, notes]
  end
end

def leader_csv_record(leader)
  [leader.name, leader.slack_username, leader.email, leader.clubs.first.name]
    .map(&:strip)
end

def csv_from_report(sym)
  CSV.generate do |csv|
    CheckInReportService.new(day: 'friday', date: nil)
                        .send(sym)
                        .map { |leader| leader_csv_record leader }
                        .each { |r| csv << r }
  end
end

namespace :check_ins do
  desc 'Generate a report of all check ins'
  task meetings: :environment do
    csv_string = CSV.generate do |csv|
      csv << CheckInRecord.csv_title
      ::CheckIn.all.each do |check_in|
        r = CheckInRecord.new(
          check_in.created_at,
          check_in.leader.name,
          check_in.meeting_date,
          check_in.club.name,
          check_in.club.leaders.all.map(&:name).uniq,
          check_in.attendance,
          check_in.notes
        )

        csv << r.csv_contents
      end
    end

    puts csv_string
  end

  desc 'Get all leaders who received check ins this week'
  task received: :environment do
    puts csv_from_report(:leaders_who_received_a_check_in)
  end

  desc 'Get all leaders who responded to check ins this week'
  task responded: :environment do
    puts csv_from_report(:leaders_who_responded)
  end

  desc 'Get all leaders who did not respond to check ins this week'
  task did_not_respond: :environment do
    puts csv_from_report(:leaders_who_did_not_respond)
  end

  desc 'Get all leaders which had a meeting this week'
  task had_meeting: :environment do
    puts csv_from_report(:leaders_who_had_a_meeting)
  end

  desc 'Get all leaders who did not have a meeting this week'
  task did_not_have_meeting: :environment do
    puts csv_from_report(:leaders_who_did_not_have_a_meeting)
  end

  desc 'Get all leaders who want to have their clubs marked as dead'
  task want_to_die: :environment do
    puts csv_from_report(:leaders_who_want_to_die)
  end

  desc 'Run all commands'
  task all: ['check_ins:received', 'check_ins:responded',
             'check_ins:did_not_respond', 'check_ins:had_meeting',
             'check_ins:did_not_have_meeting',
             'check_ins:want_to_die']
end
