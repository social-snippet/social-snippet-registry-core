module SocialSnippet::Registry::WebAPI

  WebAPIv0.controllers :token do

    # GET /token
    # returns csrf token
    get :index do
      csrf_token
    end

  end

end
