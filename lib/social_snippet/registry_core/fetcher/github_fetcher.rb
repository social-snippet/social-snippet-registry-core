module SocialSnippet::RegistryCore

  class Fetcher::GitHubFetcher < Fetcher::FetcherBase

    require "octokit"
    require "json"
    require "base64"

    SNIPPET_JSON_NAME = "snippet.json"

    def snippet_json(url)
      info = parse_url(url)
      snippet_json_by info[:owner_id], info[:repo_id]
    end

    def is_github?(uri)
      return uri.scheme === "git" &&
        uri.host === "github.com" &&
        /\/[a-z0-9\-]+\/[a-z0-9\-\.\_]+\.git/ === uri.path
    end

    def parse_url(url)
      uri = URI.parse(url)
      if is_github?(uri)
        matches = /\/([a-z0-9\-]+)\/([a-z0-9\-\.\_]+)\.git/.match(uri.path)
        return {
          :owner_id => matches[1],
          :repo_id => matches[2],
        }
      else
        raise "should be passed GitHub URL"
      end
    end

    def client
      @client ||= ::Octokit::Client.new(
        :client_id => ENV["SSPM_GITHUB_CLIENT_ID"],
        :client_secret => ENV["SSPM_GITHUB_CLIENT_SECRET"],
      )
    end

    def snippet_json_by(owner_id, repo_id)
      begin
        opts = {}
        opts[:path] = SNIPPET_JSON_NAME

        # resolve version
        vers = versions(owner_id, repo_id)
        unless vers.empty?
          opts[:ref] = latest_version(vers)
        end

        contents_info = client.contents("#{owner_id}/#{repo_id}", opts)
        decoded_content = ::Base64.decode64(contents_info[:content])
        return ::JSON.parse(decoded_content)
      rescue ::Octokit::NotFound => error
        raise "not found"
      end
    end

    def refs_by(owner_id, repo_id)
      client.refs("#{owner_id}/#{repo_id}")
        .map {|ref_info| ref_info[:ref] }
        .map {|ref| ref.gsub /^refs\/[a-z]+\//, "" }
    end

  end # GitHubFetcher

end # SocialSnippet
