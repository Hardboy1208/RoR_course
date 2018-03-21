class AddUserToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :user_id, :bigint
    add_column :answers, :user_id, :bigint
  end
end
