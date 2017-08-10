class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.text :title
      t.text :description
      t.text :local_dir
      t.text :git_url
      t.text :live_url

      t.json :workspace

      t.timestamps
    end
  end
end
