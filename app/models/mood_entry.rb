class MoodEntry < ApplicationRecord
  belongs_to :user

  validates :mood_level, presence: true, inclusion: { in: 1..5 }
  validates :entry_date, presence: true

  before_validation :set_default_entry_date, on: :create

  private

  def set_default_entry_date
    self.entry_date ||= Date.today
  end
end
