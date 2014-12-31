module SocialSnippet::Registry::WebAPI::Helpers

  module RepositoryHelper

    def create_fetcher(url)
      uri = URI.parse(url)
      if is_github?(uri)
        ::SocialSnippet::RegistryCore::Fetcher::GitHubFetcher.new
      else
        raise "not supported"
      end
    end

  end

  ::SocialSnippet::Registry::WebAPI::WebAPIBase.helpers RepositoryHelper

end
