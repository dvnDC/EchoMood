class AiSuggestionJob < ApplicationJob
  queue_as :default

  def perform(mood_entry_id)
    mood_entry = MoodEntry.find_by(id: mood_entry_id)
    return unless mood_entry

    suggestion = AiSuggestionService.generate_suggestion(mood_entry.user)
    if suggestion.present?
      mood_entry.update(ai_suggestion: suggestion)

      Turbo::StreamsChannel.broadcast_replace_to(
        "ai_suggestion_#{mood_entry.user.id}",
        target: "ai_suggestion_frame",
        partial: "shared/ai_suggestion",
        locals: { latest_mood_entry: mood_entry }
      )
    end
  end
end
