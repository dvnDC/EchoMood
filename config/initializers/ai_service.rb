# AI client initialization after application startup
Rails.application.config.after_initialize do
  # Download the Llama 3 8B model at startup if it doesn't exist already
  Thread.new do
    require 'net/http'
    uri = URI("#{ENV['AI_SERVICE_URL'] || 'http://ai:11434'}/api/pull")
    req = Net::HTTP::Post.new(uri)
    req.body = { name: 'llama3:8b-q4' }.to_json
    req.content_type = 'application/json'

    begin
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      Rails.logger.info "Llama 3 8B model successfully pulled"
    rescue => e
      Rails.logger.error "Failed to pull Llama 3 8B model: #{e.message}"
    end
  end
end