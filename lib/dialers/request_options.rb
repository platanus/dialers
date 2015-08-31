module Dialers
  class RequestOptions
    attr_accessor :url, :http_method, :query_params, :payload, :headers

    def query_params
      @query_params || {}
    end

    def payload
      @payload || {}
    end

    def headers
      @headers || {}
    end
  end
end
