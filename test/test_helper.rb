require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'

require 'active_record'

require 'beholders'

require 'beholders/callback_hooks'
ActiveRecord::Base.send(:extend, Beholders::CallbackHooks)

ActiveRecord::Base.establish_connection(
  "adapter"  => "sqlite3",
  "database" => ":memory:"
)

require 'seeds'
