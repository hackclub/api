class Hackbot::Dispatcher
  CONVERSATION_TYPES = [
    Hackbot::Conversations::Attendance,
    Hackbot::Conversations::Mention
  ].freeze

  def handle(event, slack_team)
    wranglers = convos_needing_handling(event)

    return wranglers.each { |w| w.handle(event); w.save! } unless wranglers.empty?

    to_create = CONVERSATION_TYPES.select { |c| c.should_start? event }
    created = to_create.map { |c| c.new(team: slack_team) }

    created.map { |c| c.handle(event); c.save! }
  end

  protected

  def convos_needing_handling(event)
    Hackbot::Conversation.where.not(state: :finish)
                         .select { |c| c.is_part_of_convo? event }
  end
end
