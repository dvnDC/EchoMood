class CreateEmotionEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :emotion_entries do |t|
      t.integer :valence, null: false
      t.integer :arousal, null: false
      t.text :notes
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.datetime :entry_time, null: false

      t.timestamps
    end
    add_index :emotion_entries, [:user_id, :date, :entry_time]
  end
end
