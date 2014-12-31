ENV["RACK_ENV"] = "test"

require "bundler/setup"
require "spec_helpers/rack_test_helper"
require "spec_helpers/database_cleaner_helper"
require "spec_helpers/factory_girl_helper"

# Boot Padrino
require_relative "../config/boot"