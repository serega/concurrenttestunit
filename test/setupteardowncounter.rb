
require "test/unit"
require 'test/unit/concurrent/concurrenttestcase'

class SetupTeardownCounter < Test::Unit::Concurrent::ConcurrentTestCase

  @@class_setup_call_count = Hash.new(0)
  @@class_teardown_call_count = Hash.new(0)

  def setup_suite
    @@class_setup_call_count[self.class] += 1
  end


  def teardown_suite
    @@class_teardown_call_count[self.class] += 1
  end

  def self.setup_suite_call_count
    return @@class_setup_call_count[self]
  end

  def self.teardown_suite_call_count
    return @@class_teardown_call_count[self]
  end
  
end
