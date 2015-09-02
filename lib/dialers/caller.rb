module Dialers
  class Caller
    HTTP_METHODS = [:post, :put, :patch, :get, :head, :options, :delete]
    IDEMPOTENT_AND_SAFE_METHODS = [:get, :head, :options]
    BODY_HOLDER_METHODS = [:post, :put, :patch]
    MAX_RETRIES = 5

    def self.setup_api(*args, &block)
      api = Faraday.new(*args) { |faraday| block.call(faraday) }
      const_set "API", api
    end

    def self.short_circuits
      @short_circuits ||= Dialers::ShortCircuitsCollection.new
    end

    BODY_HOLDER_METHODS.each do |http_method|
      define_method(http_method) do |url, payload = {}, headers = {}|
        options = RequestOptions.new
        options.url = url
        options.http_method = http_method
        options.payload = payload
        options.headers = headers

        transform(http_call(options))
      end
    end

    (HTTP_METHODS - BODY_HOLDER_METHODS).each do |http_method|
      define_method(http_method) do |url, params = {}, headers = {}|
        options = RequestOptions.new
        options.url = url
        options.http_method = http_method
        options.query_params = params
        options.headers = headers

        transform(http_call(options))
      end
    end

    private

    def transform(response)
      self.class.short_circuits.search_for_stops(response)
      Dialers::Transformable.new(response)
    end

    def http_call(request_options, current_retries = 0)
      call_api(request_options)
    rescue Faraday::ParsingError => _exception
      raise Dialers::ParsingError.new(exception)
    rescue Faraday::ConnectionFailed => exception
      raise Dialers::UnreachableError.new(exception)
    rescue Faraday::TimeoutError => exception
      retry_call(request_options, exception, current_retries)
    end

    def retry_call(request_options, exception, current_retries)
      if idempotent_and_safe_method?(request_options.http_method) && current_retries <= MAX_RETRIES
        http_call(request_options, current_retries + 1)
      else
        fail Dialers::UnreachableError.new(exception)
      end
    end

    def call_api(request_options)
      api.public_send(
        request_options.http_method, request_options.url, request_options.query_params || {}
      ) do |request|
        request.body = request_options.payload
        (request_options.headers || {}).each do |key, value|
          request.headers[key] = value
        end
      end
    end

    def api
      @api ||= get_api
    end

    def get_api
      self.class::API
    rescue NameError
      raise Dialers::InexistentApiError.new(self.class)
    end

    def idempotent_and_safe_method?(http_method)
      IDEMPOTENT_AND_SAFE_METHODS.include?(http_method)
    end

    def body_holder_method?(http_method)
      BODY_HOLDER_METHODS.include?(http_method)
    end
  end
end
