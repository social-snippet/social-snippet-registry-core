class SocialSnippet::RegistryCore::Models::UserAccount

  include ::Mongoid::Document
  include ::Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :github_user_id, :type => Integer
  field :github_access_token, :type => String
  field :github_repos, :type => Array

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
  
  def github_repos_names
    github_repos.map do |repo_name|
      { :name => repo_name, }
    end
  end

  def self.find_by_id(s)
    if s.nil?
      nil
    else
      begin
        find s
      rescue
        nil
      end
    end
  end

end
