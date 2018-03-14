# frozen_string_literal: true

class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.text :type

      t.timestamps
    end
  end
end
