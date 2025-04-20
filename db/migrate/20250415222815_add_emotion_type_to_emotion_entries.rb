class AddEmotionTypeToEmotionEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :emotion_entries, :emotion_type, :string
  end
end
