namespace :weather do
  desc "Import data from Api"
  task import: :environment do
    WeatherCache.download
  end
end