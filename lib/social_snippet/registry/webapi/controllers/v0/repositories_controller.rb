module SocialSnippet::Registry::WebAPI

  WebAPIv0.controllers :repositories do

    # GET /repositories
    get :index, :provides => :json do
      if params[:q].nil?
        Repository.all_repos.to_json
      else
        Repository.query(params[:q]).to_json
      end
    end

    # GET /repositories/{repo-name}
    get :index, :with => [:id] do
      repo_model = Repository.find_by(:name => params[:id])
      repo_model.to_object.to_json
    end

    # POST /repositories
    #
    # @param url [String]
    post :index, :provides => :json do
      repo_url = normalize_url(params[:url])
      fetcher = create_fetcher(repo_url)

      info = fetcher.snippet_json(repo_url)
      repo = Repository.create_by_snippet_json(info)
      repo.url = repo_url
      repo.save!

      {
        :name => repo.name,
        :status => "ok",
      }.to_json
    end

  end # controllers

end # WebAPI
