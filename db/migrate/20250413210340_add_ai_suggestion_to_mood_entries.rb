class AddAiSuggestionToMoodEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :mood_entries, :ai_suggestion, :text
  end
end
