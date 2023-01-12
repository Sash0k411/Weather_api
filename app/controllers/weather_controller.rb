class WeatherController < ApplicationController
  def historical_min
    temperature = Forecast.historical.minimum(:temperature)
    render json: { temperature: temperature }
  end

  def historical_max
    temperature = Forecast.historical.maximum(:temperature)
    render json: { temperature: temperature }
  end

  def historical_avg
    temperature = Forecast.historical.average(:temperature).round(1)
    render json: { temperature: temperature }
  end

  def current
    temperature = Forecast.sorted.first.temperature
    render json: { temperature: temperature }
  end

  def historical
    temperatures = Temperature.historical
    render json: { data: temperatures }
  end

  def by_time
    temperature = Temperature.by_time!(params[:timestamp]).temperature
    render json: { temperature: temperature }
  end
end
