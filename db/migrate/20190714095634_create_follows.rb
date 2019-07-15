class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :user, foreign_key: { to_table: :users }
      t.references :follow_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
