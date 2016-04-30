require_relative 'connection'

module HttpClient
  class Request
    include Connection

    HTTP_METHODS = [:get, :head, :post, :put, :delete, :patch]

    METHODS_WITH_BODIES = [:post, :put, :patch]

    attr_reader :action, :path, :params, :options, :headers

    def initialize(action, path, params = {}, options = {}, headers = {})
      @action = action.to_sym

      %W{path params options headers}.each do |field|
        instance_variable_set("@#{field}", instance_eval(field))
      end
    end

    def call
      raise HttpClient::ArgumentError unless HTTP_METHODS.include?(action)

      response = connection.send(action) do |request|
        request.url path
        request.headers.merge!(headers)

        case action
        when *(HTTP_METHODS - METHODS_WITH_BODIES)
          request.params = params if params.present?
        when *METHODS_WITH_BODIES
          request.body = options unless options.blank?
        end
      end

      response
    end

    class << self
      def get(path, params = {}, headers = {})
        self.call(:get, path, params, {}, headers)
      end

      def delete(path, params = {}, headers = {})
        self.call(:delete, path, params, {}, headers)
      end

      def head(path, params = {}, headers = {})
        self.call(:head, path, params, {}, headers)
      end

      def put(path, options = {}, headers = {})
        self.call(:put, path, {}, options, headers)
      end

      def patch(path, options = {}, headers = {})
        self.call(:patch, path, {}, options, headers)
      end

      def post(path, options = {}, headers = {})
        self.call(:post, path, {}, options, headers)
      end

      def call(action, path, params = {}, options = {}, headers = {})
        HttpClient::Response.new self.new(action, path, params, options, headers).call
      rescue Exception => e
        HttpClient::ErrorResponse.new body: {errors: {message: e.message}}.to_json
      end
    end
  end
end
