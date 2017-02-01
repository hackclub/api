class Record
  attr_accessor :created_at, :meeting_date, :club_name, :leader_names,
                :attendance, :notes

  def initialize(created_at, meeting_date, club_name, leader_names, attendance,
                 notes)
    @created_at = created_at
    @meeting_date = meeting_date
    @club_name = club_name
    @leader_names = leader_names
    @attendance = attendance
    @notes = notes
  end

  def self.csv_title
    ['Check In Completion Timestamp', 'Meeting Date', 'Club Name', 'Leaders',
     'Attendance', 'Notes']
  end

  def csv_contents
    [created_at, meeting_date, club_name, leader_names.join(', '), attendance,
     notes]
  end
end

desc 'Generate a report of all check ins'
task check_ins: :environment do
  csv_string = CSV.generate do |csv|
    csv << Record.csv_title
    ::CheckIn.all.each do |check_in|
      r = Record.new(
        check_in.created_at,
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
