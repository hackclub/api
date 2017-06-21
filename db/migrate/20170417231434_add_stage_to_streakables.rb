class AddStageToStreakables < ActiveRecord::Migration[5.0]
  STREAK_API_BASE = 'https://www.streak.com/api'.freeze
  STREAK_API_KEY = Rails.application.secrets.streak_api_key

  CLUB_PIPELINE_KEY = 'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiINemFjaGxhdHR'\
    'hLmNvbQwLEghXb3JrZmxvdxiAgICA6P2XCgw'.freeze
  CLUB_TABLE_NAME = 'clubs'.freeze
  LEADER_PIPELINE_KEY = 'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiINemFjaGxhd'\
    'HRhLmNvbQwLEghXb3JrZmxvdxiAgICAqoeSCgw'.freeze
  LEADER_TABLE_NAME = 'leaders'.freeze
  LETTERS_PIPELINE_KEY = 'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiINemFjaGxh'\
    'dHRhLmNvbQwLEghXb3JrZmxvdxiAgICA4LCFCgw'.freeze
  LETTERS_TABLE_NAME = 'letters'.freeze

  def change
    add_column :clubs, :stage_key, :text
    add_column :leaders, :stage_key, :text
    add_column :letters, :stage_key, :text

    reversible do |change|
      change.up do
        set_stage_on_models CLUB_PIPELINE_KEY, CLUB_TABLE_NAME
        set_stage_on_models LEADER_PIPELINE_KEY, LEADER_TABLE_NAME
        set_stage_on_models LETTERS_PIPELINE_KEY, LETTERS_TABLE_NAME
      end
    end
  end

  private

  def set_stage_on_models(pipeline_key, table_name)
    resp = RestClient::Request.execute(
      method: :get,
      url: pipeline_url(pipeline_key),
      headers: {
        'Authorization' => auth_header
      }
    )

    boxes = JSON.parse resp.body

    boxes.each do |box|
      record = select_one "SELECT * FROM #{table_name} WHERE streak_key = "\
                          "'#{box['key']}'"

      unless record.nil?
        update "UPDATE #{table_name} SET stage_key = '#{box['stageKey']}' "\
               "WHERE streak_key = '#{box['key']}'"
      end
    end
  end

  def pipeline_url(key)
    STREAK_API_BASE + "/v1/pipelines/#{key}/boxes"
  end

  def auth_header
    "Basic #{Base64.strict_encode64(STREAK_API_KEY + ':')}"
  end
end
