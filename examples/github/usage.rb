require_relative "./api"

username = ARGV.first
github = Github::Api.new

begin
  github.user_repos(username).each do |repository|
    puts repository.to_s
  end
rescue Dialers::NotFoundError
  puts "Not Found Username #{username}."
end
