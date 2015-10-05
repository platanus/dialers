module Dialers
  class MockableCaller
    def mock_routes(&routes_definition)
      self.routes_definition = MockedRoutesDefinition.new(&routes_definition)
    end

    %i(get head delete options post put patch).each do |http_method|
      define_method(http_method) do |url, params = {}, headers = {}|
        mocked_response = MockedResponse.new(
          http_method: http_method,
          url: url,
          params: params,
          headers: headers,
          routes_definition: routes_definition
        )
        Dialers::Transformable.new(mocked_response)
      end
    end

    private

    attr_accessor :routes_definition
  end

  class MockedRoutesDefinition
    def initialize(&block)
      self.routes = []
      self.current_response = {}
      block.call(self)
    end

    def to(http_method, url)
      self.current_response = route_from(http_method, url)
      routes << current_response
      self
    end

    def respond_with(status, body)
      current_response[:status] = status
      current_response[:body] = body
    end

    def get_route(http_method, url)
      routes.find do |route|
        route[:http_method] == http_method && route[:url] == url
      end
    end

    private

    def route_from(http_method, url)
      { http_method: http_method, url: url }
    end

    attr_accessor :routes, :current_response
  end

  class MockedResponse
    def initialize(http_method: nil, url: "", params: {}, headers: {}, routes_definition: nil)
      self.http_method = http_method
      self.url = url
      self.params = params
      self.headers = headers
      self.route = routes_definition.get_route(http_method, url)

      if route.nil?
        fail "Route is not defined for: #{http_method} to #{url}."
      end
    end

    def status
      route[:status]
    end

    def body
      route[:body]
    end

    private

    attr_accessor :http_method, :url, :params, :headers, :route
  end
end
