require "rack/test"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

# You can use this method to custom specify a Rack app
# you want rack-test to invoke:
#
#   app Hoge::App
#   app Hoge::App.tap { |a| }
#   app(Hoge::App) do
#     set :foo, :bar
#   end
def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
