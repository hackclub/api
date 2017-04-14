module Hackbot
  module Interactions
    module Concerns
      module LeaderAssociable
        extend ActiveSupport::Concern

        def leader
          pipeline_key = Rails.application.secrets.streak_leader_pipeline_key
          slack_id_field = :'1020'

          @leader_box ||= StreakClient::Box
                          .all_in_pipeline(pipeline_key)
                          .find do |b|
                            b[:fields][slack_id_field] == slack_id
                          end

          @leader ||= Leader.find_by(streak_key: @leader_box[:key])
        end
      end
    end
  end
end
