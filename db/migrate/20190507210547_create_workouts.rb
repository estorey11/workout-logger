class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.integer :bodyweight
      t.date :date
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
