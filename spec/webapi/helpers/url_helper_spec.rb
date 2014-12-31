require "spec_helper"

module ::SocialSnippet::Registry::WebAPI::Helpers

  describe UrlHelper do

    include UrlHelper

    context "with .git" do

      context "https" do
        subject { normalize_url("https://github.com/user/repo.git") }
        it { should eq "git://github.com/user/repo.git" }
      end

      context "http" do
        subject { normalize_url("http://github.com/user/repo.git") }
        it { should eq "git://github.com/user/repo.git" }
      end

      context "git" do
        subject { normalize_url("git://github.com/user/repo.git") }
        it { should eq "git://github.com/user/repo.git" }
      end

    end # without .git

    context "without .git" do

      context "https" do
        subject { normalize_url("https://github.com/user/repo") }
        it { should eq "git://github.com/user/repo.git" }
      end

      context "http" do
        subject { normalize_url("http://github.com/user/repo") }
        it { should eq "git://github.com/user/repo.git" }
      end

      context "git" do
        subject { normalize_url("git://github.com/user/repo") }
        it { should eq "git://github.com/user/repo.git" }
      end

    end # without .git

  end # url_helper

end # ::SocialSnippet::Registry::WebAPI::Helpers
