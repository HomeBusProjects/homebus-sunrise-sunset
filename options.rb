require 'homebus_app_options'

class SunriseSunsetHomeBusAppOptions < HomeBusAppOptions
  def app_options(op)
    latitude_help = 'the latitude of the reporting area'
    longitude_help = 'the longitude of the reporting area'

    op.separator 'SunriseSunset options:'
    op.on('-t', '--latitude LATITUDE', latitude_help) { |value| options[:latitude] = value }
    op.on('-g', '--longitude LONGITUDE', longitude_help) { |value| options[:longitude] = value }
  end

  def banner
    'HomeBus Sunrise/Sunset Publisher'
  end

  def version
    '0.0.1'
  end

  def name
    'homebus-sunrise-sunset'
  end
end
