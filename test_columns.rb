# This scripts tests loading a bunch of column oriented data into InfluxDB
# See the README for more info

require 'pp'
require 'colored'
require './influx'

db          = "testcolsdb"
time        = 1414008300
chunk_size  = 4000
point_count = 1000000

puts "Data from this test will be pushed into the DB: #{db}".yellow.bold

# measurement, source, source_index, fields
sources = [
  [ :sensors, :weather_0, [:air_temp, :solar_rad, :solar_par, :rh, :rain_freq, :air_pressure] ],
  [ :sensors, :esmini_0, [:air_temp, :solar_rad, :solar_par, :rh, :fanspeed, :cc_count, :cc_state] ],
  [ :sensors, :esmini_1, [:air_temp, :solar_rad, :solar_par, :rh, :fanspeed, :cc_count, :cc_state] ]
]

puts "Building #{point_count} data point lines for #{sources.count} series...".bold.blue

lines = []
point_count.times do
  sources.each do |array|
    val = rand(500..50000)
    measurement, sensor, fields = *array
    line = "#{measurement},sensor=#{sensor}"
    _fields = []
    fields.each do |field|
      _fields << "#{field}=#{rand(1000..50000)}"
    end
    line+= " #{_fields.join(',')} #{time}"
    lines << line
  end

  time+= 1
end

Influx.drop db
Influx.create db
Influx.write_lines db, lines, chunk_size