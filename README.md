# Dialers

Dialers is a gem that allows to easily create wrappers over external HTTP apis using [Faraday](https://github.com/lostisland/faraday).

## Installation

Add this line to your Gemfile:

```ruby
gem "dialers"
```

And then execute:

    $ bundle

Additionally, if you want to use a Faraday adapter different from the default one (`net_http`, based on the built-in ruby library), you have to install the gem for that. For example, to use [patron](https://github.com/toland/patron) you have to add `gem "patron"` to your Gemfile. For simplicity, this readme will use the default `net_http` adapter.

## Usage

We will use the Github API public part as a example. First, you need at least two classes: one to keep your api methods and another one to keep the api connection configuration. Let's start with this:

```ruby
module Github
  class Api < Dialers::ApiWrapper
  end

  class ApiCaller < Dialers::Caller
  end
end
```

Now, let's configure our github api. It's important to note that this configuration is the same that Faraday uses (indeed, it's passed to Faraday as it is):

```ruby
module Github
  class ApiCaller < Dialers::Caller
    TIMEOUT_IN_SECONDS = 5
    GITHUB_API_URL = "https://api.github.com"

    setup_api(url: GITHUB_API_URL) do |faraday|
      faraday.request :json
      faraday.request :request_headers, accept: "application/vnd.github.v3+json"
      faraday.response :json
      faraday.adapter :net_http
      faraday.options.timeout = TIMEOUT_IN_SECONDS
      faraday.options.open_timeout = TIMEOUT_IN_SECONDS
    end
  end
end
```

If you want to know more about how to configure Faraday to some different and more complex use cases, please check the [configuration documentation](todo:linktodocumentation). Now that the configuration is over, let's plug the caller into the wrapper to be able to create some methods.

```ruby
module Github
  class Api < Dialers::ApiWrapper
    api_caller { Github::ApiCaller }

    def user_repos(username)
      api_caller.get("users/#{username}/repos").as_received
    end
  end
end
```

Let's try this:

```ruby
github = Github::Api.new
github.user_repos("rails")
# => [ { ... }] # An enormous array of hashes
```

Now, this sucks for us because we don't have any kind of schema nor classes here. Let's add something to organize this response:

```ruby
module Github
  class Repository
    attr_accessor :id, :name, :description, :language
  end

  class Api < Dialers::ApiWrapper
    api_caller { Github::ApiCaller }

    def user_repos(username)
      api_caller.get("users/#{username}/repos").transform_to_many(Github::Repository)
    end
  end
end
```

Using `transform_to_many` we mapped the response body to many `Github::Repository` objects. Let's try now:

```ruby
github = Github::Api.new
repositories = github.user_repos("rails")
repositories.first.name # maybe Rails
```

You can use `post`, `put`, `patch`, `options`, `get` and `head` on the callers. You can use `transform_to_one` to make just one object and you can pass a hash to decide which object to instantiate depending on the response's status. For more info, you can check out [the caller's documentation](todo:linktodocumentation).

## Some Rails Nice Things

In Rails, you can use the next command to generate a dialer wrapper:

```bash
$ rails g dialers:api anexternalservice
```

This will generate the following structure:

```
dialers/
  anexternalservice/
    api.rb
    api_caller.rb
```

Everything else is the same. This is just a proposal for a organization friendly to Rails. But, if you want, you can use any class organization you want.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To run the examples in the examples directory you have to setup some environment variables as defined in `.rbenv-vars-example` and run the examples like this:

```
$ ruby -Ilib examples/github/usage.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/platanus/dialers.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
