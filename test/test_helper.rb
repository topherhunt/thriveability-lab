ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "capybara-screenshot/minitest"
require "mocha/mini_test"
require "maxitest/autorun"
require "support/factories"
require 'support/global_helpers'
require 'support/controller_helpers'
require 'support/feature_helpers'

# Monkeypatch Minitest to provide full backtrace on assertion failures
# instead of the default 1 line (which strongly discourages using helper methods)
module Minitest
  module Assertions
    def assert test, msg = nil
      self.assertions += 1
      unless test then
        msg ||= "Expected #{mu_pp test} to be truthy."
        msg = msg.call if Proc === msg
        raise "Assertion failed.\n  #{msg}"
      end
      true
    end # def
  end # module
end # module
