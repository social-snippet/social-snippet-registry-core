module SocialSnippet::RegistryCore::CommonHelpers

  def assets_host
    if ENV["SSPM_ASSETS_HOST"].nil?
      ""
    else
      "//#{ENV["SSPM_ASSETS_HOST"]}"
    end
  end

end
