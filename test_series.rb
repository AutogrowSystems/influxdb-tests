# This scripts tests loading a bunch of series oriented data into InfluxDB
# See the README for more info

require 'pp'
require 'colored'
require './influx'

db          = "testdb"
time        = 1414008300
chunk_size  = 4000
point_count = 1000000

puts "Data from this test will be pushed into the DB: #{db}".yellow.bold

# Each of these lines represents a series
sources = [
  [ :air_temp, :weather_0 ],
  [ :solar_rad, :weather_0 ],
  [ :solar_par, :weather_0 ],
  [ :rh, :weather_0 ],
  [ :rain_freq, :weather_0 ],
  [ :air_pressure, :weather_0 ],
  [ :air_temp, :esmini_0 ],
  [ :solar_rad, :esmini_0 ],
  [ :solar_par, :esmini_0 ],
  [ :rh, :esmini_0 ],
  [ :fanspeed, :esmini_0 ],
  [ :cc_count, :esmini_0 ],
  [ :cc_state, :esmini_0 ],
  [ :air_temp, :esmini_1 ],
  [ :solar_rad, :esmini_1 ],
  [ :solar_par, :esmini_1 ],
  [ :rh, :esmini_1 ],
  [ :fanspeed, :esmini_1 ],
  [ :cc_count, :esmini_1 ],
  [ :cc_state, :esmini_1 ]
]

lines = []

puts "Building #{point_count} data point lines for #{sources.count} series...".bold.blue

point_count.times do
  sources.each do |array|
    val = rand(500..50000)
    measurement, sensor = *array
    line = "#{measurement},sensor=#{sensor}"
    line+= " value=#{val} #{time}"
    lines << line
  end

  time+= 1
end

Influx.drop db
Influx.create db
Influx.write_lines(db, lines, chunk_size)



