# This script simply runs some queries and pretty prints them
# so we can investigate the JSON structure coming out from
# the Influx API

require 'pp'
require 'colored'
require './influx'

db = 'testcolsdb'

puts "\nSeries:".bold.green
pp Influx.query "SHOW SERIES", db

puts "\nMeasurements:".bold.green
pp Influx.query "SHOW MEASUREMENTS", db

puts "\nHow many data points:".bold.green
pp Influx.query "SELECT count(air_temp) FROM sensors", db

puts "\nShow some of the points:".bold.green
pp Influx.query "SELECT * FROM sensors LIMIT 3", db

puts "\nShow only air temps:".bold.green
pp Influx.query "SELECT air_temp FROM sensors WHERE sensor = 'weather_0' LIMIT 3", db