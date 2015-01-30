class SocialSnippet::Registry::WebAPI::Repository

  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  #
  # field <name>, :type => <type>, :default => <value>
  #

  # Repository's Name (e.g. "my-repo")
  field :name, :type => String

  # Repository's URL (e.g. "git://github.com/user/repo.git")
  field :url, :type => String

  # Repository's description (e.g. "This is my repository.")
  field :desc, :type => String

  # Repository's dependencies (e.g. ["dep-to-1", "dep-to-2", ...])
  field :dependencies, :type => Array, :default => []

  # Repository's license (e.g. MIT)
  field :license, :type => String

  # Target programming languages (e.g. C++, Ruby)
  field :languages, :type => Array, :default => []

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>
  index({name: 1}, {unique: true})

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
 
  #
  # validations
  #
  validates_presence_of :name
  validates_presence_of :url
  validates_length_of :name, :minimum => 1, :maximum => 64
  validates_length_of :desc, :maximum => 200
  validates_length_of :url, :maximum => 256
  validates_length_of :license, :maximum => 64

  validate do
    errors[:name] << "Invalid name" unless self.class.is_valid_repo_name?(name)
    errors[:url] << "Invalid URL" unless self.class.is_valid_url?(url)
    if dependencies.is_a?(Array)
      errors[:dependencies] << "invalid dependencies" if has_invalid_dependencies?
      errors[:dependencies] << "The size of dependencies must be less than 64" if dependencies.length > 64
    end
    if languages.is_a?(Array)
      errors[:languages] << "The size of languages must be less than 64" if languages.length > 64
    end
  end

  def has_invalid_dependencies?
    dependencies.any? {|dep_name| not self.class.is_valid_repo_name?(dep_name) }
  end

  def has_invalid_language?
    languages.any? {|language| not self.class.is_valid_language?(lang) }
  end

  #
  # methods
  #
  
  FIELD_KEYS = [
    :name,
    :url,
    :desc,
    :dependencies,
    :license,
    :languages,
  ]
  
  def to_object
    FIELD_KEYS.reduce({}) do |obj, key|
      obj[key.to_sym] = self[key]
      obj
    end
  end

  def update_by_snippet_json(json_obj)
    filter = %w(
      desc
    )
    repo_info = json_obj.select {|k, v| filter.include? k }
    write_attributes repo_info
    # deps: hash to array
    self.dependencies = json_obj["dependencies"] && json_obj["dependencies"].keys
  end

  class << self

    def is_github_url?(url)
      return false unless is_valid_url?(url)
      uri = ::URI.parse(url)
      "github.com" === uri.host && /^\/[^\/]+\/[^\/]+$/ === url.path
    end

    def is_valid_url?(url)
      return false unless /^(http|https|git)\:\/\// === url
      uri = ::URI.parse(url)
      if "github.com" === uri.host
        return false unless /^\/[^\/]+\/[^\/]+$/ === uri.path
        return true
      end

      false
    end

    def is_valid_language?(language)
      /^[a-zA-Z0-9\.\-\_\+\#]+$/ === language
    end

    def is_valid_repo_name?(repo_name)
      /^[a-z][a-z0-9\.\-\_]*$/ === repo_name
    end

    def all_repos
      all.map {|repo| repo.to_object }
    end

    def query(s)
      where(:name => /#{s}/).map {|repo| repo.to_object } # TODO
    end

    def create_by_snippet_json(json_obj)
      model = find_or_create_by(:name => json_obj["name"])
      model.update_by_snippet_json json_obj
      return model
    end

  end # class << self

end # Repository
