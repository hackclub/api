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
      wranglers = interactions_needing_handling(event)

      return wranglers.each { |w| run_interaction(w, event) } unless wranglers.empty?

      to_create = INTERACTION_TYPES.select do |c|
        c.should_start?(event, slack_team)
      end

      created = to_create.map { |c| c.new(team: slack_team) }

      created.each do |c|
        run_interaction(c, event)
      end
    end

    private

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
