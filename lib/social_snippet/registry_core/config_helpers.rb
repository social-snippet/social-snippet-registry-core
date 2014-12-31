module SocialSnippet::RegistryCore::ConfigHelpers

  require "padrino"
  require "rack/session/dalli"
  require "rack/parser"
  require "rack/tracker"
  require "omniauth-github"

  #
  # call from padrino-app
  #

  def sspm_enable_tracker
    unless ENV["SSPM_GOOGLE_ANALYTICS"].nil?
      use ::Rack::Tracker do
        handler :google_analytics, { tracker: ENV["SSPM_GOOGLE_ANALYTICS"] }
      end
    end
  end

  def sspm_enable_json_params
    logger.info "Enable JSON Params: #{self}"

    use ::Rack::Parser, :parsers => {
      "application/json" => proc { |data| JSON.parse data },
    }
  end

  def sspm_enable_user_access_control
    if settings.sspm_session
      logger.info "Enable User Access Control: #{self}"

      register ::Padrino::Admin::AccessControl
      set :admin_model, "UserAccount"
      set :login_page, :login
      enable :authentication
      enable :store_location

      # check session
      before do
        if session[:user] && ( not logged_in? )
          set_current_account session[:user]
        end
      end
    end
  end

  def sspm_enable_omniauth
    return if @sspm_enable_omniauth_visited
    @sspm_enable_omniauth_visited = true

    if settings.sspm_session
      logger.info "Enable GitHub Authentication: #{self}"

      use OmniAuth::Builder do
        provider(
          :github,
          ENV["SSPM_GITHUB_CLIENT_ID"],
          ENV["SSPM_GITHUB_CLIENT_SECRET"],
          {
            :provider_ignores_state => true, # TODO: re-check
          }
        )
      end
    end
  end

  def sspm_enable_session
    if settings.sspm_session
      logger.info "Enable Session: #{self}"

      set :protection, false
      set :protect_from_csrf, false
      disable :sessions

      if ENV["SSPM_MEMCACHED_USERNAME"].nil?
        memcached_client = Dalli::Client.new(ENV["SSPM_MEMCACHED_HOST"])
      else
        memcached_client = Dalli::Client.new(
          ENV["SSPM_MEMCACHED_HOST"],
          username: ENV["SSPM_MEMCACHED_USERNAME"],
          password: ENV["SSPM_MEMCACHED_PASSWORD"],
        )
      end
      use ::Rack::Session::Dalli, {
        :cache => memcached_client,
        :expire_after => 14 * 24 * 3600,
      }

      use ::Rack::Protection
      use ::Rack::Protection::AuthenticityToken, :authenticity_param => '_csrf_token'
    end
  end

end
