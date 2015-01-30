require "spec_helper"

module SocialSnippet::Registry::WebAPI

  describe Repository do

    describe "#to_object" do

      context "create model" do

        let(:model) do
          Repository.new(
            :name => "my-repo",
            :desc => "thisisdesc",
            :url => "git://url/to/git/repo",
          )
        end

        context "call to_object" do
          let(:result) { model.to_object }
          it { expect(result[:name]).to eq "my-repo" }
          it { expect(result[:desc]).to eq "thisisdesc" }
          it { expect(result[:url]).to  eq "git://url/to/git/repo" }
        end # call to_object

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
