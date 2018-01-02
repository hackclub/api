# frozen_string_literal: true

class CreateSlackAnalyticLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_analytic_logs do |t|
      t.json :data

      t.timestamps
    end
  end
end
