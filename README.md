# influxdb-tests

Our tests with InfluxDB v0.9.0

## What we test

We generate a bunch of fake data from different sensors to see how the queries work and see
what kind of filesize we end up with.

### Series based data

We write 20 different series, consisting of 9 different measurements from 3 different sensors.

An example of the schema:

```ruby
{
  database: 'testdb',
  points: [
    {
      name: 'air_temp',
      tags: {
        sensor: 'weather_0'
      },
      fields: {
        value: 2455
      }
    },
    {
      name: 'rh',
      tags: {
        sensor: 'esmini_1'
      },
      fields: {
        value: 7200
      }
    }
  ]
}
```

### Column based data

We write 3 different series, consisting of 1 measurement from 3 different sensors.

An example of the schema:

```ruby
{
  database: 'testcolsdb',
  points: [
    {
      name: 'sensors',
      tags: {
        sensor: 'weather_0'
      },
      fields: {
        air_temp:     2455,
        solar_rad:    56600,
        solar_par:    43444,
        rh:           7400,
        rain_freq:    45334,
        air_pressure: 105899
      }
    },
    {
      name: 'sensors',
      tags: {
        sensor: 'esmini_1'
      },
      fields: {
        air_temp:     2455,
        solar_rad:    56600,
        solar_par:    43444,
        rh:           7400,
        fanspeed:     2350,
        cc_state:     1,
        cc_count:     43
      }
    }
  ]
}
```

### Column based data (random)

This is exactly the same as the previous section, except we only choose 3 fields to write with every data point.  This is to simulate nulls in the database and see how it affects the overall database size.

## Results

We generated the data for 1,000,000 readings in each of the situations above, and measured the size of the database.  These are the results.

|             |  Tags | Fields | Rows Per Point | Total Rows | DB Size |
|-------------|-------|--------|----------------|---------------------|
| Series Based | 1 | 1 | 20 | 20,000,000 | 1,300 MB |
| Column Based | 1 | 6 - 7 | 3 | 3,000,000 | 497 MB |
| Column Based (Random) | 1 | 3 | 3 | 3,000,000 | 305 MB |

As you can see there are large space benefits when using a column based layout.  Also, if you don't write a column every time you will save disk space - this would be useful for only recording a field when it's value changes.

**As yet we have not done any tests for running queries as at this stage we are only worried about disk space usage.**