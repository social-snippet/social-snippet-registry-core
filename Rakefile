require 'bundler/setup'

require 'padrino-core/cli/rake'
PadrinoTasks.use(:database)
PadrinoTasks.use(:mongomapper)
PadrinoTasks.init

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = [
    "--format doc",
    "--color",
  ]
end

