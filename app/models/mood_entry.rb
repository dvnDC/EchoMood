class MoodEntry < ApplicationRecord
  belongs_to :user

  validates :mood_level, presence: true, inclusion: { in: 1..5 }
  validates :entry_date, presence: true

  before_validation :set_default_entry_date, on: :create
  after_create_commit :enqueue_ai_suggestion_job

  private

  def set_default_entry_date
    self.entry_date ||= Date.today
  end

  def enqueue_ai_suggestion_job
    AiSuggestionJob.perform_later(self.id)
  end
end
