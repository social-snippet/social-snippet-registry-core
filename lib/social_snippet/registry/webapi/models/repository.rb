class Repository

  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>

  # Repository's Name (e.g. "my-repo")
  field :name, :type => String

  # Repository's URL (e.g. "git://github.com/user/repo.git")
  field :url, :type => String

  # Repository's description (e.g. "This is my repository.")
  field :desc, :type => String

  # Repository's dependencies (e.g. ["dep-to-1", "dep-to-2", ...])
  field :dependencies, :type => Array, :default => lambda { [] }

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>
  index({name: 1}, {unique: true})

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
 
  # validations
  validates_presence_of :name
  validates_presence_of :url

  # methods
  
  FIELD_KEYS = [
    :name,
    :url,
    :desc,
    :dependencies,
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
