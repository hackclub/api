module Hackbot
  module Interactions
    module Concerns
      module LeaderAssociable
        extend ActiveSupport::Concern

        def leader
          Leader.find_by(slack_id: slack_id)
        end
      end
    end
  end
end
