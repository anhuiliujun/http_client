require "http_client/version"

module HttpClient
  class << self
    extend Forwardable

    def_delegators :request, :get, :head, :delete, :put, :patch, :post

    def request
      HttpClient::Request
    end

    def configure
      yield(configuration)
    end

  end
end

require 'forwardable'
require 'active_support/core_ext/object/blank'
require 'http_client/request'
require 'http_client/response'
require 'http_client/middleware'
require 'http_client/connection'
