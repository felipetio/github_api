namespace :github do
  desc "Fetch github data from current user and store it locally"
  task :fetch_me => :environment do |task, args|
    github_access_token ENV["GITHUB_ACCESS_TOKEN"]

    validate_arguments(github_access_token)

    connect! github_access_token

    fetch_user(@client.user)

    fetch_repos(@client.user)

    Rails.logger.info("Success fetch github data!")
  rescue Octokit::Unauthorized
    Rails.logger.error("Unable to fetch github data, ensure github_access_token is valid.")
  end

  desc "Fetch github data from a list of users and store it locally (`github:fetch[felipetio,fabiofleitas]`)"
  task :fetch => :environment do |task, args|
    connect! ENV["GITHUB_ACCESS_TOKEN"]

    if logins = args.extras and logins.empty?
      raise ArgumentError, "At least one user login must be passed via argumments"
    end

    logins.each do |login|
      user = fetch_user(login)
      fetch_repos(user)
    end

    Rails.logger.info("Success fetch github data!")
  rescue Octokit::Unauthorized
    Rails.logger.error("Unable to fetch github data, ensure github_access_token is valid.")
  end

  private

  def connect!(github_access_token)
    if not github_access_token.present?
      raise ArgumentError, "A valid github_access_token must be passed via ENV[GITHUB_ACCESS_TOKEN]"
    end

    @client = Octokit::Client.new(
                access_token: github_access_token,
                auto_paginate: true
              )
  end

  def fetch_user(user)
    user = user.is_a?(String) ? @client.user(user) : user
    Rails.logger.info("Fetching user #{user.login}")
    User.where(id: user.id).first_or_create(user.to_hash)

    user
  end

  def fetch_repos(user)
    last_response = user.rels[:repos].get

    while true do
      last_response.data.each do |repo|
        Rails.logger.info("Fetching repo #{repo.name}")
        Repository.where(id: repo.id).first_or_create(repo.to_hash)
      end

      break unless last_response.rels[:next]
      last_response = last_response.rels[:next].get
    end
  end
end
