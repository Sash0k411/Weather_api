class Forecast < ApplicationRecord
  scope :sorted, -> { order(time: :desc) }
  scope :historical, -> { sorted.limit(24) }

  def self.by_time!(timestamp)
    raise ActiveRecord::RecordNotFound unless timestamp
    raise ActiveRecord::RecordNotFound unless timestamp.match?(/\A\d+\z/)

    prev_forecast =
      Forecast.where("time <= ?", Time.at(timestamp.to_i)).sorted.first

    next_forecast =
      Forecast.where("time >= ?", Time.at(timestamp.to_i)).order(:time).first

    closest_forecast =
      [prev_forecast , next_forecast]
        .compact
        .sort_by { |forecast| (forecast.time.to_i - timestamp.to_i).abs }
        .select { |forecast| (forecast.time.to_i - timestamp.to_i).abs <= 3.hours.to_i }
        .first

    raise ActiveRecord::RecordNotFound unless closest_forecast

    closest_forecast
  end

  def as_json(*)
    super(only: %i[temperature time])
  end
end
