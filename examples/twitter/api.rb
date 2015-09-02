require_relative "./api_caller"

module Twitter
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

    def search(query)
      api_caller.get("search/tweets.json", q: query).transform_to_many(Tweet, root: "statuses")
    end
  end
end
