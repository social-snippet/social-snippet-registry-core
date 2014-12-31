require "spec_helper"

describe SocialSnippet::Registry::WebAPI::WebAPIv0 do

  describe "repository_controller" do

    app SocialSnippet::Registry::WebAPI::WebAPIv0

    let(:api_version) { '/v0' }

    context "add my-repo" do

      before do
        FactoryGirl.define do
          factory "my-repo", :class => Repository do
            name "my-repo"
            desc "This is my repository"
            url "git://github.com/user/my-repo.git"
          end 
        end # define my-repo

        FactoryGirl.create "my-repo"
      end # prepare my-repo

      context "get repositories/my-repo" do

        before { get "#{api_version}/repositories/my-repo" }
        it { expect(last_response).to be_ok }

        context "check result" do
          let(:result) { JSON.parse(last_response.body) }
          it { expect(result["name"]).to eq "my-repo" }
          it { expect(result["url"]).to eq "git://github.com/user/my-repo.git" }
          it { expect(result["desc"]).to eq "This is my repository" }
          it { expect(result["dependencies"]).to be_empty }
        end

      end

      context "get repositories" do

        before do
          get "#{api_version}/repositories"
        end

        it { expect(last_response).to be_ok }

        context "check result json" do
          let(:result) { JSON.parse(last_response.body) }
          it { expect(result.length).to eq 1 }
          it { expect(result[0]["name"]).to eq "my-repo" }
          it { expect(result[0]["url"]).to eq "git://github.com/user/my-repo.git" }
          it { expect(result[0]["desc"]).to eq "This is my repository" }
        end # check result json

      end # get repositories

      context "add new-repo" do

        context "post repositories" do

          let(:new_repo_url_raw) { "git://github.com/user/new-repo" }
          let(:new_repo_url) { URI.encode_www_form_component new_repo_url_raw }

          before do
            allow_any_instance_of(::SocialSnippet::Registry::WebAPI::WebAPIv0).to receive(:create_fetcher) do
              class Dummy; end
              dummy = Dummy.new
              allow(dummy).to receive(:snippet_json) do |_|
                {
                  "name" => "new-repo",
                  "desc" => "This is new repo",
                  "language" => "C++",
                  "main" => "src",
                  "dependencies" => {
                    "my-repo" => "1.0.0",
                  },
                }
              end
              dummy
            end
          end # clone dummy repo

          context "post by json params" do

            before do
              # TODO: check without token
              header "X-CSRF-TOKEN", "dummy-token"
              data = {
                "url" => new_repo_url_raw,
              }
              post(
                "#{api_version}/repositories",
                data.to_json,
                {
                  "CONTENT_TYPE" => "application/json",
                  "rack.session" => {
                    :csrf => "dummy-token",
                  },
                },
              )
            end

            it "", :current => true do; end # TODO: remove

            it { expect(last_response).to be_ok }

            context "check result model" do

              let(:repo) { Repository.find_by(:name => "new-repo") }
              it { expect(repo.name).to eq "new-repo" }
              it { expect(repo.url).to eq "git://github.com/user/new-repo.git" }

            end # check result model

            context "with query" do

              context "get repositories?q=new" do

                before { get "#{api_version}/repositories?q=new" }

                it { expect(last_response).to be_ok }

                context "check result json" do
                  let(:result) { JSON.parse(last_response.body) }
                  it { expect(result.length).to eq 1 }
                  it { expect(result[0]["name"]).to eq "new-repo" }
                  it { expect(result[0]["url"]).to eq "git://github.com/user/new-repo.git" }
                  it { expect(result[0]["desc"]).to eq "This is new repo" }
                end

              end # get repositories?q=new

              context "get repositories?q=my" do

                before { get "#{api_version}/repositories?q=my" }

                it { expect(last_response).to be_ok }

                context "check result json" do
                  let(:result) { JSON.parse(last_response.body) }
                  it { expect(result.length).to eq 1 }
                  it { expect(result[0]["name"]).to eq "my-repo" }
                  it { expect(result[0]["url"]).to eq "git://github.com/user/my-repo.git" }
                  it { expect(result[0]["desc"]).to eq "This is my repository" }
                end

              end # get repositories?q=new

            end # with query

          end # post by query params

          context "post by query params" do

            before do
              # TODO: check without token
              header "X-CSRF-TOKEN", "dummy-token"
              post(
                "#{api_version}/repositories?url=#{new_repo_url}",
                {
                },
                {
                  "rack.session" => {
                    :csrf => "dummy-token",
                  },
                }
              )
            end

            it { expect(last_response).to be_ok }

            context "check result model" do

              let(:repo) do
                Repository.find_by(:name => "new-repo")
              end

              it { expect(repo.name).to eq "new-repo" }
              it { expect(repo.url).to eq "git://github.com/user/new-repo.git" }
              it { expect(repo.dependencies).to_not be_empty }
              it { expect(repo.dependencies.length).to eq 1 }

            end # check result model

            context "with query" do

              context "get repositories?q=new" do

                before { get "#{api_version}/repositories?q=new" }

                it { expect(last_response).to be_ok }

                context "check result json" do
                  let(:result) { JSON.parse(last_response.body) }
                  it { expect(result.length).to eq 1 }
                  it { expect(result[0]["name"]).to eq "new-repo" }
                  it { expect(result[0]["url"]).to eq "git://github.com/user/new-repo.git" }
                  it { expect(result[0]["desc"]).to eq "This is new repo" }
                end

              end # get repositories?q=new

              context "get repositories?q=my" do

                before { get "#{api_version}/repositories?q=my" }

                it { expect(last_response).to be_ok }

                context "check result json" do
                  let(:result) { JSON.parse(last_response.body) }
                  it { expect(result.length).to eq 1 }
                  it { expect(result[0]["name"]).to eq "my-repo" }
                  it { expect(result[0]["url"]).to eq "git://github.com/user/my-repo.git" }
                  it { expect(result[0]["desc"]).to eq "This is my repository" }
                end

              end # get repositories?q=new

            end # with query

          end # post by query params

        end # post repositories

      end # add new-repo

    end # add my-repo

  end # repositories_controller

end # SocialSnippet::Registry::WebAPI::Versions::WebAPIv0
