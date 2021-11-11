#!/usr/bin/env ruby

require './options'
require './app'

sun_app_options = SunriseSunsetHomebusAppOptions.new

sun = SunriseSunsetHomebusApp.new sun_app_options.options
sun.run!
