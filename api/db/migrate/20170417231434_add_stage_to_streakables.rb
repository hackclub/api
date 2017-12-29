# frozen_string_literal: true
class AddStageToStreakables < ActiveRecord::Migration[5.0]
  STREAK_API_BASE = 'https://www.streak.com/api'
  STREAK_API_KEY = Rails.application.secrets.streak_api_key

  CLUB_PIPELINE_KEY = 'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiINemFjaGxhdHR'\
    'hLmNvbQwLEghXb3JrZmxvdxiAgICA6P2XCgw'
  CLUB_TABLE_NAME = 'clubs'
  LEADER_PIPELINE_KEY = 'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiINemFjaGxhd'\
    'HRhLmNvbQwLEghXb3JrZmxvdxiAgICAqoeSCgw'
  LEADER_TABLE_NAME = 'leaders'
  LETTERS_PIPELINE_KEY = 'agxzfm1haWxmb29nYWVyNAsSDE9yZ2FuaXphdGlvbiINemFjaGxh'\
    'dHRhLmNvbQwLEghXb3JrZmxvdxiAgICA4LCFCgw'
  LETTERS_TABLE_NAME = 'letters'

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
