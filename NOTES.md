1. Example with Twitter

```ruby
# This example requires the gem simple_oauth
module Twitter
  class ApiCaller < Dialers::Caller
    BASE_URL = "https://api.twitter.com/1.1/"
    CONSUMER_KEY = ENV["CONSUMER_KEY"]
    CONSUMER_SECRET = ENV["CONSUMER_SECRET"]
    TOKEN = ENV["TOKEN"]
    TOKEN_SECRET= ENV["TOKEN_SECRET"]

    setup_api(url: BASE_URL) do |faraday|
      faraday.request :json
      faraday.request :oauth,
        consumer_key: CONSUMER_KEY,
        consumer_secret: CONSUMER_SECRET,
        token: TOKEN,
        token_secret: TOKEN_SECRET
      faraday.response :json
      faraday.adapter :net_http
    end

    short_circuits.add(
      if: -> (response) { Dialers::Status.new(response.status).server_error? },
      do: -> (response) { fail Dialers::ServerError, response }
    )

    short_circuits.push(
      if: -> (response) { Dialers::Status.new(response.status).is?(401) },
      do: -> (response) { fail Dialers::UnauthorizedError, response }
    )

    short_circuits.add(
      if: -> { |response| Dialers::Status.new(response.status).is?(404) },
      do: -> { |response| Dialers::AssignAttributes.call(Github::Error.new, response.body) }
    )
  end

  class Tweet
    attr_accessor :created_at, :text
  end

  class User
    attr_accessor :screen_name, :profile_image_url
  end

  class Api < Dialers::Wrapper
    api_caller { ApiCaller.new }

    def get_user_timeline
      api_caller.get("statuses/user_timeline.json").transform_to_many(Tweet)
    end

    def get_user
      api_caller.get("account/verify_credentials.json").transform_to_one(User)
    end
  end
end
```
