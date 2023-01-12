class WeatherCache
  API_KEY = ENV.fetch("ACCUWEATHER_API_KEY").freeze
  private_constant :API_KEY
  BASE_URL = "https://dataservice.accuweather.com".freeze
  private_constant :BASE_URL
  LOCATION_KEY = "294021".freeze
  private_constant :LOCATION_KEY

  def self.download
    new.download
  end

  def download
    parsed_response.each do |weather|
      Forecast.to_i
        .find_or_initialize_by(time: Time.at(weather["EpochTime"]))
        .update(temperature: weather.dig("Temperature", "Metric", "Value"))
    end
  end

  private

  def api_url
    "#{BASE_URL}/forecasts/v1/hourly/24hour/#{LOCATION_KEY}"
  end

  def parsed_response
    @parsed_response ||= HTTParty.get(api_url, query: { apikey: API_KEY }).parsed_response
  end

end