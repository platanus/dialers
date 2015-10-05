require_relative "./api_caller"

module Github
  class Repository
    attr_accessor :id, :name, :description, :language

    def to_s
      "#{id} : #{name} : #{description} : #{language}"
    end
  end

  class Api < Dialers::Wrapper
    api_caller(:api) { ApiCaller.new }
    api_caller(:authorized) { ApiCaller.as(:authorized).new }
    api_caller(:super_heavy) { ApiCaller.as(:super_heavy).new }

    def user_repos(username)
      api_caller.get("users/#{username}/repos").transform_to_many(Repository)
    end

    def get_user_private_data(username)
      authorized_caller.with(username).get("users/#{username}/private")
    end

    def get_heavy_data
      super_heavy_caller.get("heavy")
    end
  end
end
