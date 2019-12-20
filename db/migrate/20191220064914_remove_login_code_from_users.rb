# frozen_string_literal: true

class RemoveLoginCodeFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :login_code, :text
    remove_column :users, :login_code_generation, :datetime
  end
end
