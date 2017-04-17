module Hackbot
  module Interactions
    class AdminCommand < Command
      before_handle :ensure_admin

      protected

      def ensure_admin
        return if current_admin?

        if state == 'start'
          msg_channel admin_copy('when_in_start_state')
        else
          send_msg(event[:user], admin_copy('when_in_progress'))
        end

        throw :abort
      end

      def admin_copy(key, hash = {})
        copy(key, hash, 'admin_command')
      end
    end
  end
end
