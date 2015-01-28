require "spec_helper"

module SocialSnippet::RegistryCore::Models

  describe UserAccount do

    let(:user) do
      UserAccount.new(
        :github_repos => [
          "foo/bar"
        ]
      )
    end

    subject { user.github_repos_names.map {|r| r[:name] } }
    it { should include "foo/bar" }

  end

end

