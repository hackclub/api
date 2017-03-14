module Hackbot
  class Dispatcher
    INTERACTION_TYPES = [
      Hackbot::Interactions::CheckIn,
      Hackbot::Interactions::DiceRoll,
      Hackbot::Interactions::Gifs,
      Hackbot::Interactions::Help,
      Hackbot::Interactions::SetPoc,
      Hackbot::Interactions::Stats
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
      pending_interactions.each { |i| run_interaction(i, event) }
    end

    def trigger_new_interactions(event, slack_team)
      to_create = INTERACTION_TYPES.select do |c|
        c.should_start?(event, slack_team)
      end

      created = to_create.map { |c| c.new(team: slack_team) }

      created.each do |c|
        run_interaction(c, event)
      end
    end

    def run_interaction(interaction, event)
      interaction.with_lock do
        interaction.handle(event)
        interaction.save!
      end
    end

    def interactions_needing_handling(event)
      Hackbot::Interaction.where.not(state: :finish)
                          .select { |c| c.part_of_interaction? event }
    end
  end
end
