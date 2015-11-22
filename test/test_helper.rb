require File.expand_path(File.dirname(__FILE__) + '/../redmine/test/test_helper')

module Redmine
  module PluginFixturesLoader
    def fixture(name)
      ActiveRecord::FixtureSet.identify name
    end

    def self.included(base)
      base.class_eval do
        def self.plugin_fixtures(*symbols)
          ActiveRecord::FixtureSet.create_fixtures(File.dirname(__FILE__) + '/fixtures/', symbols)
        end
      end
    end
  end
end

module ActiveSupport
  class TestCase
    include Redmine::PluginFixturesLoader
    self.use_transactional_fixtures = true
  end
end
