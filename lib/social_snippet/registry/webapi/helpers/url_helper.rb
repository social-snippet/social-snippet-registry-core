module SocialSnippet::Registry::WebAPI::Helpers

  module UrlHelper

    def normalize_url(url)
      uri = URI.parse(url)
      if is_github?(uri)
        uri.scheme = "git"
      end
      if is_github?(uri) && has_no_dot_git?(uri)
        uri.path += ".git"
      end
      uri.to_s
    end

    def is_github?(uri)
      uri.host === "github.com" && /^\// === uri.path
    end

    def has_no_dot_git?(uri)
      not /\.git$/ === uri.path
    end

  end

  ::SocialSnippet::Registry::WebAPI::WebAPIBase.helpers UrlHelper

end

