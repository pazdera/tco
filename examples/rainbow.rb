#!/usr/bin/env ruby

require "tco"

conf = Tco.config
conf.names["purple"] = "#622e90"
conf.names["dark-blue"] = "#2d3091"
conf.names["blue"] = "#00aaea"
conf.names["green"] = "#02a552"
conf.names["yellow"] = "#fdea22"
conf.names["orange"] = "#f37f5a"
conf.names["red"] = "#eb443b"
Tco.reconfigure conf

rainbow = ["purple", "dark-blue", "blue", "green", "yellow", "orange", "red"]
10.times do
  rainbow.each { |colour| print "    ".bg colour }
  puts
end
