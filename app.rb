# coding: utf-8

require 'klang'
require 'faraday'
require 'json'

class GoogleTranslateApi
  # see also: https://cloud.google.com/translate/

  def initialize(key)
    @key = key
    @conn = Faraday::Connection.new(:url => 'https://translation.googleapis.com') do |builder|
      builder.request :url_encoded
      builder.adapter :net_http
    end
  end
  
  def translate(word)
    response = @conn.post do |req|
      req.url '/language/translate/v2'
      req.headers['Content-Type'] = 'application/json'
      req.params['key'] = @key
      req.body = {
        'source' => 'ko',
        'target' => 'en',
        'format' => 'text',
        'q' => word
      }.to_json
    end

    JSON.parse(response.body)['data']['translations'][0]['translatedText'].sub(/^\s*/, '').chomp
  end

end

def multiline_comment?(line)
  line =~ /^\s+\* /
end

def oneline_comment?(line)
  line =~ /\/\//
end

def parse_comment_body(line)
  result = line.gsub(/^.*\/\/\s*/, '').gsub(/^\s*\*\s*/, '').chomp
  result.gsub(/^(TODO|FIXME)\s?:?\s*/, '\1: ')
end

def include_korean?(body)
  body.chars.each do |c|
    if Klang::Klang.hangul? c
      return true
    end
  end
  false
end

# -----

key = nil
filename = nil

if ARGV.size == 2
  key = ARGV.shift
  filename = ARGV.shift
else
  puts "#{$0} GOOGLE_API_KEY SRC_FILE"
  exit 0
end

koen = GoogleTranslateApi.new(key) if key

modified = false
data = []
File.open(filename, 'r') do |f|
  f.each_line do |line|
    data << line
    if oneline_comment?(line) or multiline_comment?(line)
      body = parse_comment_body(line)

      if include_korean? body
        puts "Detected korean comment: #{body}"
        space = line.match(/^\s*/)[0]
        if oneline_comment? line
          data << "#{space}// #{koen.translate(body)}" if key
          modified = true
        elsif multiline_comment? line
          data << "#{space}* #{koen.translate(body)}" if key
          modified = true
        end

        sleep 5
      end
    end
  end
end

if modified
  File.open(filename, 'w') do |f|
    data.each do |line|
      f.puts line
    end
  end
end
