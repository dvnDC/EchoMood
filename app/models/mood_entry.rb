class MoodEntry < ApplicationRecord
  belongs_to :user

  validates :mood_level, presence: true, inclusion: { in: 1..5 }
  validates :entry_date, presence: true, uniqueness: { scope: :user_id } # One mood entry per day per user.
end
