FactoryBot.define do
  factory :emotion_entry do
    valence { 1 }
    arousal { 1 }
    notes { "MyText" }
    user { nil }
    date { "2025-04-08" }
  end
end
