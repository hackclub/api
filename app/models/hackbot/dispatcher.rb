module Hackbot
  class Dispatcher
    CONVERSATION_TYPES = [
      Hackbot::Conversations::CheckIn,
      Hackbot::Conversations::Gifs,
      Hackbot::Conversations::Help,
      Hackbot::Conversations::SetPoc,
      Hackbot::Conversations::Stats
    ].freeze

    def handle(event, slack_team)
      wranglers = convos_needing_handling(event)

      return wranglers.each { |w| run_convo(w, event) } unless wranglers.empty?

      to_create = CONVERSATION_TYPES.select do |c|
        c.should_start?(event, slack_team)
      end

      created = to_create.map { |c| c.new(team: slack_team) }

      created.each do |c|
        run_convo(c, event)
      end
    end

    private

    def run_convo(convo, event)
      convo.with_lock do
        convo.handle(event)
        convo.save!
      end
    end

    def convos_needing_handling(event)
      Hackbot::Conversation.where.not(state: :finish)
                           .select { |c| c.part_of_convo? event }
    end
  end
end
