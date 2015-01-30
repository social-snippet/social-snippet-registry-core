require "spec_helper"

module SocialSnippet::Registry::WebAPI

  describe Repository do

    describe "#to_object" do

      context "create model" do

        let(:model) do
          Repository.create!(
            :name => "my-repo",
            :desc => "this is my repo",
            :url => "git://github.com/user/my-repo.git",
          )
        end

        describe "#to_object" do
          let(:result) { model.to_object }
          it { expect(result[:name]).to eq "my-repo" }
          it { expect(result[:desc]).to eq "this is my repo" }
          it { expect(result[:url]).to  eq "git://github.com/user/my-repo.git" }
        end # call to_object

        context "fetch snippet.json" do

          before do
            WebMock.stub_request(
              :get,
              "https://api.github.com/repos/user/my-repo/git/refs",
            ).to_return(
              :status => 200,
              :body => [
                {
                  :ref => "refs/heads/master",
                },
              ].to_json,
              :headers => {
                "Content-Type" => "application/json",
              },
            )

            WebMock.stub_request(
              :get,
              "https://api.github.com/repos/user/my-repo/contents/snippet.json",
            ).to_return(
              :status => 200,
              :body => {
                :content => ::Base64.encode64({
                  :name => "new-my-repo",
                  :desc => "this is new my repo",
                }.to_json),
              }.to_json,
              :headers => {
                "Content-Type" => "application/json",
              },
            )
          end # github api

          before { model.fetch }
          it { expect(model.name).to eq "my-repo" }
          it { expect(model.desc).to eq "this is new my repo" }

        end

      end # create model

    end # to_object

    describe "#update_by_snippet_json" do

      context "create model" do

        let(:model) do
          Repository.create!(
            :name => "my-repo",
            :desc => "thisisdesc",
            :url => "git://github.com/user/repo",
          )
        end

        it { expect(model.origin_type).to eq Repository::ORIGIN_TYPE_GITHUB }

        context "create repo" do

          let(:json_obj) do
            {
              "name" => "new-repo",
              "desc" => "this is new desc",
              "dependencies" => {
                "my-repo" => "1.0.0",
              },
            }
          end

          context "call update_by" do

            before { model.update_by_snippet_json(json_obj) }

            context "call to_object" do
              let(:result) { model.to_object }
              it { expect(result[:name]).to eq "my-repo" }
              it { expect(result[:desc]).to eq "this is new desc" }
              it { expect(result[:dependencies]).to include "my-repo" }
            end

          end

        end

      end # create model

    end # update_by_real_repo

  end # Repository

end # SocialSnippet::Registry::WebAPI
