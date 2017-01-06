module Hackbot
  class Dispatcher
    CONVERSATION_TYPES = [
      Hackbot::Conversations::CheckIn,
      Hackbot::Conversations::Mention
    ].freeze

    def handle(event, slack_team)
      wranglers = convos_needing_handling(event)

      return wranglers.each { |w| run_convo(w, event) } unless wranglers.empty?

      to_create = CONVERSATION_TYPES.select { |c| c.should_start? event }
      created = to_create.map { |c| c.new(team: slack_team) }

      created.each { |c| run_convo(c, event) }
    end

    private

    def run_convo(convo, event)
      convo.handle(event)
      convo.save!
    end

    def convos_needing_handling(event)
      Hackbot::Conversation.where.not(state: :finish)
                           .select { |c| c.part_of_convo? event }
    end
  end
end
