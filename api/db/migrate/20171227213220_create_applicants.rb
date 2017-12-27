class CreateApplicants < ActiveRecord::Migration[5.0]
  def change
    create_table :applicants do |t|
      t.text :email

      t.text :login_code
      t.datetime :login_code_generation

      t.text :auth_token
      t.datetime :auth_token_generation

      t.timestamps
    end
  end
end
