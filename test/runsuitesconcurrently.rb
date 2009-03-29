$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit/concurrent/concurrenttestunit'


require 'slowtests'
require 'test_hash'
require 'test_random'

# Run two suites concurrently.
# Each test withing the suites will concurrently
# with respect to each other.
# So, at the end we get all tests in all suites
# running concurrently.
class RunSuitesConcurrently < Test::Unit::Concurrent::ConcurrentTestSuite

  def initialize(name)
    super(name)
  end

  def self.suite
    executor = Test::Unit::Concurrent::Executor.new(6)
    suite = self.new("RunSuitesConcurrently")
    suite.executor = executor
    suite << TestHash.suite
    suite << TestRand.suite
    suite << SlowTest.suite
    suite << SlowTest2.suite
    suite.tests.each do |s|
      if s.instance_of? Test::Unit::Concurrent::ConcurrentTestSuite
        s.executor = executor
      end
    end
    suite.after_suite(lambda { executor.shutdown })
    return suite
  end
end


Test::Unit::Concurrent::ConcurrentTestRunner.run(RunSuitesConcurrently)

include Test::Unit::Assertions

assert_equal(1, SlowTest.setup_suite_call_count)
assert_equal(1, SlowTest.teardown_suite_call_count)

assert_equal(1, SlowTest2.setup_suite_call_count)
assert_equal(1, SlowTest2.teardown_suite_call_count)             

