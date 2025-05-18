class MoodEntry < ApplicationRecord
  belongs_to :user

  validates :mood_level, presence: true, inclusion: { in: 1..5 }
  validates :entry_date, presence: true, uniqueness: { scope: :user_id,
                                                       message: "You can only create one mood entry per day. Edit your existing entry instead." }

  before_validation :set_default_entry_date, on: :create
  after_create_commit :enqueue_ai_suggestion_job

  def self.mood_level_options
    {
      1 => "1 - Very Low",
      2 => "2 - Low",
      3 => "3 - Neutral",
      4 => "4 - Good",
      5 => "5 - Very Good"
    }
  end

  def mood_level_description
    self.class.mood_level_options[mood_level]
  end

  private

  def set_default_entry_date
    self.entry_date ||= Date.today
  end

  def enqueue_ai_suggestion_job
    AiSuggestionJob.perform_later(self.id)
  end
end
