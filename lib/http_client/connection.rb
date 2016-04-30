require_relative 'middleware'
require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module HttpClient
  module Connection
    def default_options
      {
        headers: {
          "Accept"         => 'application/json,text/plain,text/html; charset=utf-8',
          "Accept-Charset" => 'utf-8',
          "User-Agent"     => 'Mozilla/16.0.0 (X11; Linux x86_64; rv:2.0.1) Gecko/20150101 Firefox/16.0.0'
        },
        request: {
          timeout: 60 # seconds
        }
      }
    end

    def connection
      @connection ||= Faraday.new(default_options, &HttpClient::Middleware.default)
    end
  end
end
