class CreateWorkshopProjectClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :workshop_project_clicks do |t|
      t.belongs_to :workshop_project, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.inet :ip_address
      t.text :referrer
      t.text :user_agent
      t.integer :type_of, default: 0

      t.timestamps
    end
  end
end
