class Executer
  def execute(query)
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

  private

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
    class Sql < AdminCommand
      TRIGGER = /sql (?<query>.*)/

      USAGE = 'sql <query>'.freeze
      DESCRIPTION = 'execute the given SQL query and return the results '\
                    '(staff only)'.freeze

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
        msg_channel CodeFormatterService.new(res).format
      end

      def cancel
        send_action_result(copy('confirm.cancel'))
      end
    end
  end
end
