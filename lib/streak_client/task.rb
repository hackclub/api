module StreakClient
  module Task
    class << self
      def all_in_box(box_key)
        StreakClient.request(:get, "/v2/boxes/#{box_key}/tasks")[:results]
      end

      def find(task_key)
        StreakClient.request(:get, "/v2/tasks/#{task_key}")
      end

      def create(box_key, text, due_date: nil, assignees: [])
        StreakClient.request(
          :post, "/v2/boxes/#{box_key}/tasks", {
            text: text,
            due_date: time_to_ms_since_epoch(due_date),
            assigned_to_sharing_entries:
              construct_sharing_entries(assignees).to_json
          },
          {},
          false
        )
      end

      def update(task_key, params)
        # If the user passes assignees to update, transform the given array of
        # emails into proper sharing entries.
        if params.key? :assignees
          assignees = params[:assignees] || []

          params[:assigned_to_sharing_entries] =
            construct_sharing_entries(assignees)

          params.delete(:assignees)
        end

        # If the user passes a due date to update, similarly transform it to
        # milliseconds since epoch
        if params.key? :due_date
          params[:due_date] = time_to_ms_since_epoch(params[:due_date])
        end

        StreakClient.request(:post, "/v2/tasks/#{task_key}", params)
      end

      def delete(task_key)
        StreakClient.request(:delete, "/v2/tasks/#{task_key}")
      end

      private

      # Converts an array of emails to a formatted Streak sharing entry, ready
      # to be passed to Streak's API.
      #
      # Example:
      #
      #   [ "foo@example.com", "sally@foobar.com" ]
      #
      #   turns into
      #
      #   [ { email: "foo@example.com" }, { email: "sally@foobar.com" } ]
      #
      #   which you can then pass to any Streak endpoint that requests a
      #   "sharing entry" -- you may have to serialize this to a JSON string for
      #   certain endpoints (I'm looking at you POST /v2/:box_key/tasks)
      def construct_sharing_entries(emails)
        emails.map { |e| { email: e } }
      end

      def time_to_ms_since_epoch(time)
        (time.to_f * 1000).to_i
      end
    end
  end
end
