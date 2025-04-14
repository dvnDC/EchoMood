class MoodEntry < ApplicationRecord
  belongs_to :user

  validates :mood_level, presence: true, inclusion: { in: 1..5 } # Update articles with this data - meditation and patterns!
  validates :entry_date, presence: true

  before_validation :set_default_entry_date, on: :create
  after_create :generate_ai_suggestion

  private

  def set_default_entry_date
    self.entry_date ||= Date.today
  end

  def generate_ai_suggestion
    suggestion = AiSuggestionService.generate_suggestion(user)
    update_column(:ai_suggestion, suggestion) if suggestion.present?
  end
end
