#!/usr/bin/env ruby

require "tco"

rainbow = ["#622e90", "#2d3091", "#00aaea", "#02a552", "#fdea22", "#eb443b", "#f37f5a"]
10.times do
  rainbow.each { |colour| print "    ".bg colour }
  puts
end
