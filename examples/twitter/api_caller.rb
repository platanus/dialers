require "dialers"

module Twitter
  class ApiCaller < Dialers::Caller
    BASE_URL = "https://api.twitter.com/1.1/"
    CONSUMER_KEY = ENV["TWITTER_CONSUMER_KEY"]
    CONSUMER_SECRET = ENV["TWITTER_CONSUMER_SECRET"]
    TOKEN = ENV["TWITTER_TOKEN"]
    TOKEN_SECRET = ENV["TWITTER_TOKEN_SECRET"]

    setup_api(url: BASE_URL, ssl: { verify: true }) do |faraday|
      faraday.request :json
      faraday.request :oauth,
        consumer_key: CONSUMER_KEY,
        consumer_secret: CONSUMER_SECRET,
        token: TOKEN,
        token_secret: TOKEN_SECRET
      faraday.request :request_headers, accept: "*/*"
      faraday.response :json
      faraday.adapter :patron
    end

    short_circuits.add(
      if: -> (response) { Dialers::Status.new(response.status).server_error? },
      do: -> (response) { fail Dialers::ServerError.new(response) }
    )

    short_circuits.add(
      if: -> (response) { Dialers::Status.new(response.status).is?(400) },
      do: -> (response) { fail Dialers::ResponseError.new(response) }
    )

    short_circuits.add(
      if: -> (response) { Dialers::Status.new(response.status).is?(401) },
      do: -> (response) { fail Dialers::UnauthorizedError.new(response) }
    )

    short_circuits.add(
      if: -> (response) { Dialers::Status.new(response.status).is?(404) },
      do: -> (response) { fail Dialers::NotFoundError.new(response) }
    )
  end
end
