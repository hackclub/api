class CreateLetters < ActiveRecord::Migration[5.0]
  def change
    create_table :letters do |t|
      t.text :name
      t.text :streak_key
      t.text :letter_type
      t.text :what_to_send
      t.text :address
      t.decimal :final_weight
      t.text :notes

      t.timestamps
    end
  end
end
