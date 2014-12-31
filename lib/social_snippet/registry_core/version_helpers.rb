module SocialSnippet::RegistryCore::VersionHelpers

  class << self

    # Check given text whether matches version pattern
    def test_version(pattern, version)
      return true if pattern == "" || pattern.nil?
      return true if pattern == version
      # "2.1.0" and "2.1.1" match "2.1"
      # "2.11.0" and "2.11.1" do not match "2.1"
      return version.start_with?("#{pattern}.")
    end

    # Check given text is version string
    def is_version?(s)
      return /^([0]|[1-9][0-9]*)\.([0]|[1-9][0-9]*)\.([0]|[1-9][0-9]*)$/ === s
    end

  end

end # VersionHelpers
