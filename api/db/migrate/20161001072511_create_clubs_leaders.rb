# frozen_string_literal: true
class CreateClubsLeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :clubs_leaders, id: false do |t|
      t.belongs_to :club, index: true
      t.belongs_to :leader, index: true
    end
  end
end
