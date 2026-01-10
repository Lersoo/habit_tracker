class CreateHabits < ActiveRecord::Migration[8.1]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :frequency, null: false, default: 0
      t.string :color, null: false, default: "#3b82f6"
      t.boolean :archived, null: false, default: false

      t.timestamps
    end

    add_index :habits, %i[user_id archived]
  end
end
