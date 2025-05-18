class EmotionEntry < ApplicationRecord
  belongs_to :user

  validates :valence, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -10, less_than_or_equal_to: 10 }
  validates :arousal, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -10, less_than_or_equal_to: 10 }
  validates :date, presence: true, uniqueness: { scope: :user_id,
                                                 message: "You can only create one emotion entry per day. Edit your existing entry instead." }

  validates :entry_time, presence: true

  # Auxiliary methods for determining the emotion quadrant
  def quadrant
    case
    when valence >= 0 && arousal >= 0
      1  # Top right - positive, high arousal
    when valence < 0 && arousal >= 0
      2  # Top left - negative, high arousal
    when valence < 0 && arousal < 0
      3  # Bottom left - negative, low arousal
    when valence >= 0 && arousal < 0
      4  # Bottom right - positive, low arousal
    end
  end

  def predicted_emotion
    case quadrant
    when 1
      if valence.abs > 7 && arousal.abs > 7
        "Euforia/Euphoria"
      elsif valence.abs > 7
        "Radość/Joy"
      elsif arousal.abs > 7
        "Podekscytowanie/Excitement"
      else
        "Zadowolenie/Satisfaction"
      end
    when 2
      if valence.abs > 7 && arousal.abs > 7
        "Wściekłość/Rage"
      elsif valence.abs > 7
        "Złość/Anger"
      elsif arousal.abs > 7
        "Zdenerwowanie/Nervousness"
      else
        "Frustracja/Frustration"
      end
    when 3
      if valence.abs > 7 && arousal.abs > 7
        "Głęboki smutek/Deep sadness"
      elsif valence.abs > 7
        "Przygnębienie/Depression"
      elsif arousal.abs > 7
        "Znużenie/Weariness"
      else
        "Smutek/Sadness"
      end
    when 4
      if valence.abs > 7 && arousal.abs > 7
        "Głęboki spokój/Deep peace"
      elsif valence.abs > 7
        "Błogość/Bliss"
      elsif arousal.abs > 7
        "Relaks/Relaxation"
      else
        "Zadowolenie/Satisfaction"
      end
    end
  end
end
