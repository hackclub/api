class CreateTechDomainRedemptions < ActiveRecord::Migration[5.0]
  def change
    create_table :tech_domain_redemptions do |t|
      t.text :name
      t.text :email
      t.text :requested_domain

      t.timestamps
    end
  end
end
