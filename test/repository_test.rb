require "spec_helper"

describe ::SocialSnippet::Registry::WebAPI::Repository do

  describe "validations" do

    let(:repo) { ::SocialSnippet::Registry::WebAPI::Repository.create }

    describe "valid cases" do

      after { expect(repo).to be_valid }
      after { expect { repo.save! }.to_not raise_error }

      example do
        repo.name = "my-repo"
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "my-repo-2"
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "my-repo.py"
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "my-repository"
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "new-repo"
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "foo"
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "foo.cpp"
        repo.url = "git://github.com/user/repo"
      end

    end # valid cases

    describe "invalid cases" do

      after { expect(repo).to_not be_valid }
      after { expect { repo.save! }.to raise_error }

      example do
        repo.name = "123"
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "invalid@example.com"
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "foo"
        repo.dependencies = ["foo", "123"]
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "foo"
        repo.dependencies = ["foo", "invalid@example.com"]
        repo.url = "git://github.com/user/repo"
      end

      example do
        repo.name = "foo"
        repo.url = "file:///etc/passwd"
      end

      example do
        repo.name = "foo"
        repo.url = "file:///etc/passwd"
      end

    end

  end # validations

end # ::SocialSnippet::Registry::WebAPI::Repository

