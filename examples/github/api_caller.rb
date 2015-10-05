require "dialers"

module Github
  class ApiCaller < Dialers::Caller
    TIMEOUT_IN_SECONDS = 5
    GITHUB_API_URL = "https://api.github.com"

    as :authorized do |request, username|
      request.headers["lallaa"] = username
    end

    as :super_heavy do |request|
      request.header["heavy"] = "HEAVY"
    end

    setup_api(url: GITHUB_API_URL) do |faraday|
      faraday.request :json
      faraday.request :request_headers, accept: "application/vnd.github.v3+json"
      faraday.response :json
      faraday.adapter :net_http
      faraday.options.timeout = TIMEOUT_IN_SECONDS
      faraday.options.open_timeout = TIMEOUT_IN_SECONDS
    end

    short_circuits.add(
      if: -> (response) { Dialers::Status.new(response.status).server_error? },
      do: -> (response) { fail Dialers::ServerError.new(response) }
    )

    short_circuits.add(
      if: -> (response) { Dialers::Status.new(response.status).is?(404) },
      do: -> (response) { fail Dialers::NotFoundError.new(response) }
    )
  end
end
