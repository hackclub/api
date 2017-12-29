# frozen_string_literal: true
class CreateNetPromoterScoreSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :net_promoter_score_surveys do |t|
      t.integer :score
      t.text :could_improve
      t.text :done_well
      t.text :anything_else
      t.references :leader, foreign_key: true

      t.timestamps
    end
  end
end
