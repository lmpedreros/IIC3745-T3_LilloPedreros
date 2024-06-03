class JokeApiService
  include HTTParty
  base_uri 'https://v2.jokeapi.dev'

  def self.fetch_joke(category = 'Any', type = 'single')
    response = get("/joke/#{category}/#{type}?safe-mode")
    if response.code == 200
      parsed_response = JSON.parse(response.body)
      if parsed_response['type'] == 'single'
        return parsed_response['joke']
      elsif parsed_response['type'] == 'twopart'
        return "#{parsed_response['setup']}\n#{parsed_response['delivery']}"
      end
    end
    'No se pudo obtener un chiste en este momento. Inténtalo más tarde.'
  end
end
