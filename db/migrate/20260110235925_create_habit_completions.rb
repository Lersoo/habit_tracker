class CreateHabitCompletions < ActiveRecord::Migration[8.1]
  def change
    create_table :habit_completions do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :completed_on, null: false
      t.integer :status, null: false, default: 0
      t.text :note

      t.timestamps
    end

    add_index :habit_completions, %i[habit_id completed_on], unique: true
  end
end
