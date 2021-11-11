require 'homebus/options'

class SunriseSunsetHomebusAppOptions < Homebus::Options
  def app_options(op)
    latitude_help = 'the latitude of the reporting area'
    longitude_help = 'the longitude of the reporting area'
    once_help = 'run once and exit'

    op.separator 'SunriseSunset options:'
    op.on('-t', '--latitude LATITUDE', latitude_help) { |value| options[:latitude] = value }
    op.on('-g', '--longitude LONGITUDE', longitude_help) { |value| options[:longitude] = value }
    op.on('-1', '--once', once_help) { options[:once] = true }
  end

  def banner
    'HomeBus Sunrise/Sunset Publisher'
  end

  def version
    '0.1.0'
  end

  def name
    'homebus-sunrise-sunset'
  end
end
