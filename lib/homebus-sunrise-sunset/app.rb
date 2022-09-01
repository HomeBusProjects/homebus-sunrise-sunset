# coding: utf-8
require 'homebus'
require 'dotenv'

require 'time'

class HomebusSunriseSunset::App < Homebus::App
  DDC = 'org.homebus.experimental.solar-clock'

  def initialize(options)
    @options = options
    super
  end

  def update_interval
    60*60*24
  end

  def setup!
    Dotenv.load('.env')

    @latitude = options[:latitude] || ENV['LATITUDE']
    @latitude = @latitude.to_f

    @longitude = options[:longitude] || ENV['LONGITUDE']
    @longitude = @longitude.to_f

    @location = options[:location] || ENV['LOCATION']

    unless @latitude && @longitude && @location
      abort 'Requires LATITUDE, LONGITUDE and LOCATION in .env or command-line options'
    end

    @device = Homebus::Device.new name: "Sunrise Sunset times at #{@location}",
                                  manufacturer: 'Homebus',
                                  model: 'Sunrise/sunset publisher',
                                  serial_number: "#{@latitude} N #{@longitude} W"
  end

  def _get_times
    s = <<END_OF_TIME
hdate: ALERT: time zone not entered, using system local time zone: PST, -8:0 UTC

Thursday, 19 December 2019, 21 Kislev 5780
sunrise: 07:46
sunset: 16:28
END_OF_TIME

    s = `hdate -s -l 45.57 -L -122.69`
    m = s.match /sunrise: (\d\d):(\d\d)/
    sunrise_hour = m[1]
    sunrise_minute = m[2]

    m = s.match /sunset: (\d\d):(\d\d)/
    sunset_hour = m[1]
    sunset_minute = m[2]

    now = DateTime.now
    sunrise = DateTime.new(now.year, now.month, now.day, sunrise_hour.to_i, sunrise_minute.to_i, 0, now.zone)
    sunset = DateTime.new(now.year, now.month, now.day, sunset_hour.to_i, sunset_minute.to_i, 0, now.zone)

    return sunrise, sunset
  end

  def work!
    sunrise, sunset = _get_times

    if options[:verbose]
      puts "sunrise #{sunrise.to_s}"
      puts "sunset #{sunset.to_s}"
    end

    answer = {
      sunrise: sunrise.to_time.to_i,
      sunset: sunset.to_time.to_i
    }

    if options[:verbose]
      pp answer
    end
          
    @device.publish! DDC, answer

    if options[:once]
      exit
    end

    sleep update_interval
  end

  def name
    'Sunrise/Sunset times'
  end

  def publishes
    [ DDC ]
  end

  def devices
    [ @device ]
  end
end
