# frozen_string_literal: true
class CheckInReportService
  def initialize(day:, date:)
    day_of = day.nil? ? date : Chronic.parse(day, context: :past)

    throw(Exception, "Need to specify a 'day' or a 'date'") if day_of.nil?

    day_of = day_of.utc

    min_day = day_of - 1.day
    max_day = day_of + 1.day

    @interactions = Hackbot::Interactions::CheckIn
                    .where(state: 'finish')
                    .where('created_at >= ?', min_day)
                    .where('created_at <= ?', max_day)
  end

  def leaders_who_received_a_check_in
    @interactions
      .map(&:leader)
  end

  def leaders_who_had_a_meeting
    @interactions
      .where("data->>'attendance' IS NOT NULL")
      .map(&:leader)
  end

  def leaders_who_did_not_have_a_meeting
    @interactions
      .where("data->>'attendance' IS NULL")
      .map(&:leader)
  end

  def leaders_who_responded
    @interactions
      .where("data->>'failed_to_complete' IS NULL")
      .map(&:leader)
  end

  def leaders_who_did_not_respond
    @interactions
      .where("data->>'failed_to_complete' = 'true'")
      .map(&:leader)
  end

  def leaders_who_want_to_die
    @interactions
      .where("data->>'wants_to_be_dead' = 'true'")
      .map(&:leader)
  end
end
