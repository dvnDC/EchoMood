class CreateMoodEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :mood_entries do |t|
      t.integer :mood_level
      t.text :note
      t.date :entry_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
