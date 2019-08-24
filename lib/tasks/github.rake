namespace :github do
  desc "Fetch github data and store it locally"
  task :fetch, [:github_access_token] => :environment do |task, args|
    github_access_token = args[:github_access_token] || ENV["GITHUB_ACCESS_TOKEN"]
    validate_arguments(github_access_token)
    
    client = Octokit::Client.new(:access_token => github_access_token)

    User.first_or_create(client.user.to_hash)
    client.repositories.each {|r| Repository.first_or_create(r.to_hash) }

    Rails.logger.info("Success fetch github data!")
  rescue Octokit::Unauthorized
    Rails.logger.error("Unable to fetch github data, ensure github_access_token is valid.")
  end

  private
  def validate_arguments(github_access_token)
    if not github_access_token.is_a?(String) or github_access_token.empty?
      raise ArgumentError, "A valid github_access_token must be passed via argumment or ENV"
    end
  end
end
