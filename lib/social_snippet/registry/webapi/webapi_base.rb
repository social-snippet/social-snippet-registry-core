module SocialSnippet::Registry::WebAPI

  require "social_snippet/registry_core/fetcher"
  require "mongoid"
  require "uri"

  class WebAPIBase < ::Padrino::Application
    register Padrino::Helpers
    sspm_enable_json_params
  end

end # WebAPI
