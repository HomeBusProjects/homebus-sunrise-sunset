# coding: utf-8
require 'homebus'
require 'homebus_app'
require 'mqtt'
require 'dotenv'
require 'json'

require 'time'

class SunriseSunsetHomeBusApp < HomeBusApp
  DDC = 'org.homebus.experimental.solar-clock'

  def initialize(options)
    @options = options
    super
  end

  def update_delay
    60*60*24
  end

  def setup!
    Dotenv.load('.env')

    @latitude = options[:latitude].to_i || ENV['LATITUDE'].to_i
    @longitude = options[:longitude].to_i || ENV['LONGITUDE'].to_i

    unless @latitude && @longitude
      abort 'Requires latitude and longitude in .env or command-line options'
    end

#    @calculator = SolarEventCalculator.new Date.today, @latitude, @longitude
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
      id: @uuid,
      timestamp: Time.now.to_i
    }

    answer[DDC] = {
      sunrise: sunrise.to_time.to_i,
      sunset: sunset.to_time.to_i
    }

    if options[:verbose]
      pp answer
    end
          
    publish! DDC, answer

    sleep update_delay

    if options[:once]
      exit
    end
  end

  def manufacturer
    'HomeBus'
  end

  def model
    'Sunrise/Sunset times'
  end

  def friendly_name
    'Sunrise/sunset times'
  end

  def friendly_location
    'Portland, OR'
  end

  def serial_number
    "#{@latitude} N #{@longitude} W"
  end

  def pin
    ''
  end

  def devices
    [
      { friendly_name: 'Sunrise Sunset times',
        friendly_location: 'Portland, OR',
        update_frequency: update_delay,
        index: 0,
        accuracy: 0,
        precision: 0,
        wo_topics: [ 'org.homebus.sunrise-sunset' ],
        ro_topics: [],
        rw_topics: []
      }
    ]
  end
end
