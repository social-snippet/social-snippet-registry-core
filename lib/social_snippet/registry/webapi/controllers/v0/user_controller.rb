module SocialSnippet::Registry::WebAPI

  WebAPIv0.controllers :user do

    sspm_enable_session
    sspm_enable_user_access_control

    get "/repositories", :provides => :json do
      halt 403 unless logged_in?
      if current_account.github_repos.nil?
        return {}.to_json
      end
      current_account.github_repos.map do |repo_name|
        {
          :name => repo_name,
        }
      end.to_json
    end

    put "/repositories", :provides => :json do
      client = ::Octokit::Client.new(:access_token => current_account.github_access_token)
      client.auto_paginate = true
      repos = SortedSet.new

      user_repos = client.repos.select do |repo|
        repo["permissions"]["admin"]
      end.map do |repo|
        repo["full_name"]
      end

      org_repos = client.orgs.map do |org|
        client.org_repos(org.login, {:type => "all"}).select do |repo|
          repo["permissions"]["admin"]
        end.map do |repo|
          repo["full_name"]
        end
      end.flatten

      repos.merge user_repos
      repos.merge org_repos
      
      current_account.update_attributes :github_repos => repos.to_a

      current_account.github_repos_names.to_json
    end

  end

end
