class AddAuthTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auth_type, :integer
  end
end
