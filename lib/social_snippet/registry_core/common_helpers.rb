module SocialSnippet::RegistryCore::CommonHelpers

  # called from view
  def is_logged_in
    logged_in?
  end

  def assets_host
    if ENV["SSPM_ASSETS_HOST"].nil?
      ""
    else
      "//#{ENV["SSPM_ASSETS_HOST"]}"
    end
  end

end
