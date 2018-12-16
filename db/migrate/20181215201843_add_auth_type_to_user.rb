class AddAuthTypeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auth_type, :string, default: 'auth_code'
    add_column :users, :totp_key, :string, default: nil
  end
end
