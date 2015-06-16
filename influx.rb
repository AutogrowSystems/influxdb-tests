require 'colored'
require 'httparty'
require 'cgi'


class Influx
  include HTTParty
  format :json
  base_uri "localhost:8086"

  def self.create(db)
    self.query("CREATE DATABASE #{db}")
  end

  def self.drop(db)
    self.query "DROP DATABASE #{db}"
  end

  def self.write(db, lines, precision='s')
    uri = "/write?db=#{db}&precision=#{precision}"
    self.post uri, body: lines.join("\n")
  end
  
  def self.query(q, db=nil)
    uri = "query?q=#{CGI.escape(q)}"
    uri+= "&db=#{db}" if db
    self.get "/#{uri}"
  end

  def self.write_lines(db, lines, chunk_size=4000, precision='s')
    total     = lines.count
    completed = 0
    puts "Throwing #{total} lines at the API...".blue.bold

    start         = Time.now
    request_count = 0
    lines.each_slice(chunk_size) do |slice|
      begin
        self.write(db, slice)
      rescue TypeError
        # because the write op returns a 204 no content it has no content
        # HTTParty doesn't handle that well and complains about being given
        # a nil value for it's response body
      end
      request_count+= 1
      completed += chunk_size
      print "\r#{((completed.to_f/total).to_f * 100).round(0)}% done...   ".yellow
    end
    puts ""
    finish   = Time.now
    duration = (finish - start).round(2)

    puts "Wrote #{total} lines in #{request_count} requests in #{duration} seconds".green.bold
  end
end