# frozen_string_literal: true

# This is a more generic version of StatsService that provides general
# "interesting insights" into activity of clubs.
#
# This was originally created when implementing Hackbot::Interactions::Lookup
# and running into hurdles using StatsService directly (namely, StatsService
# requires starting with a leader, where this service works with club objects
# directly).
class ClubStatsService
  include ActionView::Helpers::DateHelper

  def initialize(club)
    @club = club
  end

  def last_meeting_date
    return nil if @club.check_ins.empty?

    ordered_check_ins.last.meeting_date
  end

  def last_meeting_attendance
    return nil if @club.check_ins.empty?

    # Need to do this instead of just doing ordered_check_ins because there can
    # be multiple check-ins for a single meeting date.
    CheckIn.where(
      club: @club,
      meeting_date: last_meeting_date
    ).average(:attendance).to_i
  end

  def meeting_count
    # We can't just do @club.check_ins because multiple check-ins can exist for
    # a single date (like in the case when we were polling every leader every
    # week).
    #
    # This counts the number of unique meeting dates that are present in the
    # club's check-ins.
    @club.check_ins.select(:meeting_date).distinct.count
  end

  def average_attendance
    return nil if @club.check_ins.empty?

    @club.check_ins.average(:attendance).to_i
  end

  private

  def ordered_check_ins
    @club.check_ins.order(:meeting_date)
  end
end
