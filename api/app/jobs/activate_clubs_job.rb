class ActivateClubsJob < ApplicationJob
  def perform
    Club
      .where('activation_date IS NOT NULL')
      .select(&:dormant)
      .select { |c| Time.zone.now > Date.parse(c.activation_date) }
      .each { |c| c.make_active }
  end
end
