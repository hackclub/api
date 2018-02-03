# frozen_string_literal: true

class AthulClubMailer < ApplicationMailer
  def check_in_recap
    india_clubs = Club.india

    @weeks = []
    @clubs = []
    @stats = {}

    4.times.each do |i|
      week_num = i + 1 # start counting at 1, not 0

      week_start = week_num.weeks.ago.beginning_of_week
      week_end = week_start.end_of_week

      week_name = week_start.strftime('%m/%d') + ' - ' + \
                  week_end.strftime('%m/%d')

      @weeks.push(
        name: week_name,
        start: week_start,
        end: week_end
      )
    end

    india_clubs.each do |club|
      club_obj = {
        name: club.name,
        check_ins: []
      }

      @weeks.each do |week|
        check_in = club.check_ins.find_by(
          '? <= meeting_date AND meeting_date >= ?',
          week[:start], week[:end]
        )

        if check_in.present?
          club_obj[:check_ins].push(check_in.attendance)
        else
          club_obj[:check_ins].push('N/A')
        end
      end

      @clubs.push(club_obj)
    end

    most_recent_check_ins = india_clubs.map do |c|
      current_week = @weeks.first

      c.check_ins.find_by(
        '? <= meeting_date AND meeting_date >= ?',
        current_week[:start], current_week[:end]
      )
    end.compact

    @stats[:club_count] = india_clubs.count
    @stats[:checked_in_count] = most_recent_check_ins.count
    @stats[:attendance] = most_recent_check_ins.map(&:attendance).sum

    mail to: 'athul@hackclub.com',
         cc: ['max@hackclub.com', 'zach@hackclub.com'],
         subject: 'Indian Clubs Check-In Recap'
  end
end
