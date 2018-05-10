# frozen_string_literal: true

class CreateWorkshopFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :workshop_feedbacks do |t|
      t.text :workshop_slug
      t.json :feedback
      t.inet :ip_address

      t.timestamps
    end
    add_index :workshop_feedbacks, :workshop_slug
    add_index :workshop_feedbacks, :ip_address
  end
end
