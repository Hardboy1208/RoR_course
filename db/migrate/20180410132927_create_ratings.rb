class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.string :retractable_type
      t.integer :retractable_id
      t.integer :user_id
      t.integer :like

      t.timestamps
    end
  end
end
