class AiSuggestionService
  def self.generate_suggestion(user)
    # Pobierz dane potrzebne do wygenerowania sugestii
    current_mood = user.mood_entries.order(entry_date: :desc).first
    mood_history = user.mood_entries.order(entry_date: :desc).limit(5)
    emotion_data = user.emotion_entries.order(created_at: :desc).first

    # Przygotuj prompt z kontekstem
    prompt = prepare_prompt(current_mood, mood_history, emotion_data)

    # Wywołaj model LLM
    response = call_llm_model(prompt)

    # Zwróć wygenerowaną sugestię
    response || fallback_suggestion(current_mood)
  end

  private

  def self.prepare_prompt(current_mood, mood_history, emotion_data)
    prompt = "Jako asystent wellbeing, pomóż użytkownikowi na podstawie danych o jego nastroju:\n"

    # Dodaj informacje o aktualnym nastroju
    if current_mood
      prompt += "- Aktualny poziom nastroju: #{current_mood.mood_level}/5\n"
      prompt += "- Komentarz: #{current_mood.note}\n" if current_mood.note.present?
    end

    # Dodaj informacje o historii nastrojów
    if mood_history.any?
      prompt += "- Historia nastrojów z ostatnich dni: #{mood_history.map(&:mood_level).join(', ')}\n"
    end

    # Dodaj dane z mapy emocji jeśli dostępne
    if emotion_data
      prompt += "- Valence: #{emotion_data.valence}, Arousal: #{emotion_data.arousal}\n"
    end

    # Poproś o wygenerowanie krótkiej, pomocnej sugestii
    prompt += "\nUtwórz krótką (max 2 zdania), empatyczną sugestię, która pomoże użytkownikowi poprawić samopoczucie. "
    prompt += "Możesz odwołać się do technik oddechowych, medytacji lub artykułów dostępnych w aplikacji."

    prompt
  end

  def self.call_llm_model(prompt)
    require 'net/http'

    uri = URI("#{ENV['AI_SERVICE_URL'] || 'http://ai:11434'}/api/generate")
    req = Net::HTTP::Post.new(uri)
    req.body = {
      model: 'llama3:8b',
      prompt: prompt,
      stream: false,
      max_tokens: 100
    }.to_json
    req.content_type = 'application/json'

    begin
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      if response.is_a?(Net::HTTPSuccess)
        json_response = JSON.parse(response.body)
        return json_response['response'].strip
      else
        Rails.logger.error "Error calling LLM model: #{response.code} - #{response.message}"
        return nil
      end
    rescue => e
      Rails.logger.error "Exception when calling LLM model: #{e.message}"
      return nil
    end
  end

  def self.fallback_suggestion(current_mood)
    suggestions = [
      "Może spróbuj krótkiej techniki oddechowej - znajdziesz ją w sekcji Medytacja.",
      "Dzisiejszy dzień może być lepszy. Zajrzyj do naszych artykułów o emocjach.",
      "Pamiętaj, że emocje przychodzą i odchodzą. Techniki uważności mogą pomóc."
    ]

    if current_mood && current_mood.mood_level <= 2
      "Widzę, że czujesz się dziś przytłoczony. #{suggestions.sample}"
    elsif current_mood && current_mood.mood_level >= 4
      "Cieszę się, że masz dobry dzień! Może to dobry moment na praktykę wdzięczności?"
    else
      suggestions.sample
    end
  end
end