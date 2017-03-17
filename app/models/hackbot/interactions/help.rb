module Hackbot
  module Interactions
    class Help < Command
      TRIGGER = /help/

      USAGE = 'help'.freeze
      DESCRIPTION = 'list available commands'.freeze

      def start
        sorted_cmds = cmds.sort { |a, b| a[:usage] <=> b[:usage] }

        msg_channel copy('help', commands: sorted_cmds,
                                 bot_mention: '@' + team.bot_username)
      end

      private

      def cmds
        Command.descendants.map do |c|
          usage = c.usage(event, team)
          desc = c.description(event, team)

          next unless usage && desc

          { usage: usage, desc: desc }
        end.compact
      end
    end
  end
end
