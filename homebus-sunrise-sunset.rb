#!/usr/bin/env ruby

require './options'
require './app'

sun_app_options = SunriseSunsetHomeBusAppOptions.new

sun = SunriseSunsetHomeBusApp.new sun_app_options.options
sun.run!
