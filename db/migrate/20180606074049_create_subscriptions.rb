class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :question_id
      t.integer :user_id

      t.timestamps
    end
    add_index :subscriptions, [:question_id, :user_id]
  end
end
