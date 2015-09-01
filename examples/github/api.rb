require_relative "./api_caller"

module Github
  class Repository
    attr_accessor :id, :name, :description, :language

    def to_s
      "#{id} : #{name} : #{description} : #{language}"
    end
  end

  class Api < Dialers::Wrapper
    api_caller { ApiCaller.new }

    def user_repos(username)
      api_caller.get("users/#{username}/repos").transform_to_many(Repository)
    end
  end
end
