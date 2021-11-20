class AddPhoneNumber < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone_number, :text
  end
end
