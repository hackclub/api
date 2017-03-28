module Hackbot
  module Interactions
    module Concerns
      module Leaderable
        extend ActiveSupport::Concern

        def leader
          pipeline_key = Rails.application.secrets.streak_leader_pipeline_key
          slack_id_field = :'1020'

          @leader_box ||= StreakClient::Box
          .all_in_pipeline(pipeline_key)
          .find { |b| b[:fields][slack_id_field] == event[:user] }

          @leader ||= Leader.find_by(streak_key: @leader_box[:key])
        end
      end
    end
  end
end
