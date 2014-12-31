module SocialSnippet::RegistryCore

  class Fetcher::FetcherBase

    require "version_sorter"

    def latest_version(vers)
      ::VersionSorter.rsort(vers).first
    end

    def versions(owner_id, repo_id)
      refs_by(owner_id, repo_id).select do |ref|
        VersionHelpers.is_version?(ref)
      end
    end

    def snippet_json(url)
      raise "not implemented"
    end

  end # FetcherBase

end
