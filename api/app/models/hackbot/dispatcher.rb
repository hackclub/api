# frozen_string_literal: true
module Hackbot
  class Dispatcher
    INTERACTION_TYPES = [
      Hackbot::Interactions::Greeter,
      Hackbot::Interactions::Accountability,
      Hackbot::Interactions::AddAdminUser,
      Hackbot::Interactions::CheckIn,
      Hackbot::Interactions::CreateSlackInviteStrategy,
      Hackbot::Interactions::DemoCheckIn,
      Hackbot::Interactions::Delete,
      Hackbot::Interactions::DeleteJoins,
      Hackbot::Interactions::DiceRoll,
      Hackbot::Interactions::Gifs,
      Hackbot::Interactions::Help,
      Hackbot::Interactions::Ledger,
      Hackbot::Interactions::Lookup,
      Hackbot::Interactions::Notify,
      Hackbot::Interactions::SetPoc,
      Hackbot::Interactions::Sql,
      Hackbot::Interactions::Stats,
      Hackbot::Interactions::UpdateWorkshops
    ].freeze

    def handle(event, slack_team)
      pending_interactions = interactions_needing_handling(event)

      if !pending_interactions.empty?
        run_pending_interactions(pending_interactions, event)
      else
        trigger_new_interactions(event, slack_team)
      end
    end

    private

    def run_pending_interactions(pending_interactions, event)
      pending_interactions.each do |i|
        i.event = event
        run_interaction(i)
      end
    end

    def trigger_new_interactions(event, slack_team)
      to_create = INTERACTION_TYPES.select do |c|
        c.should_start?(event, slack_team)
      end

      created = to_create.map { |c| c.create(team: slack_team, event: event) }

      created.each { |c| run_interaction(c) }
    end

    def run_interaction(interaction)
      interaction.with_lock do
        interaction.handle
        interaction.save!
      end
    end

    def interactions_needing_handling(event)
      Hackbot::Interaction.where.not(state: :finish)
                          .select do |c|
                            c.event = event
                            c.should_handle?
                          end
    end
  end
end
