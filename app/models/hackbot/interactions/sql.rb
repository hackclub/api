class Executer
  def execute(query)
    # Slack recommends limiting messages sent to channels to 4000 characters in
    # https://api.slack.com/rtm#limits.
    #
    # This can't be a constant because this file is reloaded whenever
    # Hackbot::Interactions::Sql and causes problems when constants are defined
    # inside of Executer.
    char_limit = 4000

    res = fmted_result_from_query(query)

    truncate(res, char_limit)
  end

  private

  def truncate(str, char_limit)
    truncated = str.first(char_limit)

    if truncated != str
      split = truncated.split("\n")

      all_but_last_line = split[0...-1]
      all_but_last_line << '...truncated...'

      all_but_last_line.join("\n")
    else
      str
    end
  end

  def fmted_result_from_query(query)
    final_res = nil

    # We need to execute the given query in a separate thread because if it
    # fails, we don't want the SQL transaction that the current interaction is
    # in to be aborted.
    #
    # Rails transactions are done by threads, so by putting this in a separate
    # thread, any queries will be executed outside of the current transaction.
    in_new_thread_with_conn do |conn|
      begin
        res = conn.execute(query)
        final_res = format_result(query, res)
      rescue ActiveRecord::StatementInvalid => e
        # Return the thrown exception converted to a string with the query
        # added, so we can display it to the user.
        #
        # We call .strip to remove the trailing newlines that PG errors
        # have.
        final_res = "> #{query}\n\n" + e.original_exception.to_s.strip
      end
    end

    final_res
  end

  def in_new_thread_with_conn(&block)
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection(&block)
    end.join
  end

  def format_result(query, pg_result)
    Terminal::Table.new(
      title: query,
      headings: pg_result.fields,
      rows: pg_result.values
    ).to_s
  end
end

module Hackbot
  module Interactions
    class Sql < Command
      TRIGGER = /sql (?<query>.*)/

      USAGE = 'sql <query>'.freeze
      DESCRIPTION = 'execute the given SQL query and return the results '\
                    '(staff only)'.freeze

      before_handle :ensure_admin

      def start
        data['query'] = captured[:query]

        msg_channel(text: copy('confirm.text', query: data['query']),
                    attachments: [actions: [{ text: 'Yes' }, { text: 'No' }]])

        :confirm
      end

      def confirm
        return unless action

        case action[:value]
        when Hackbot::Utterances.yes then execute
        when Hackbot::Utterances.no then cancel
        end
      end

      private

      def execute
        send_action_result(copy('confirm.proceed'))
        res = Executer.new.execute(data['query'])
        msg_channel to_code(res)
      end

      def cancel
        send_action_result(copy('confirm.cancel'))
      end

      # Convert the given string to a formatted Slack code block.
      def to_code(str)
        "```\n" + str + "\n```"
      end

      def ensure_admin
        return if current_admin?

        if state == 'start'
          msg_channel copy('not_admin_start')
        else
          send_msg(event[:user], copy('not_admin_in_progress'))
        end

        throw :abort
      end
    end
  end
end
