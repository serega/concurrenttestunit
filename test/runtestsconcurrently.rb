$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit/testsuite'

require 'test/unit/concurrent/concurrenttestunit'

require 'test_hash'
require 'test_random'
require 'slowtests'

require 'test/unit/assertions'


class RunTestsConcurrently < Test::Unit::TestSuite

  def initialize(name)
    super(name)
  end

  def self.suite
    suite = self.new("RunTestsConcurrently")
    suite << TestHash.suite
    suite << TestRand.suite
    suite << SlowTest3.suite
    suite << SlowTest4.suite
    return suite
  end

end

Test::Unit::Concurrent::ConcurrentTestRunner.run(RunTestsConcurrently)


include Test::Unit::Assertions
assert_equal(1, SlowTest.setup_suite_call_count)
assert_equal(1, SlowTest.teardown_suite_call_count)

assert_equal(1, SlowTest2.setup_suite_call_count)
assert_equal(1, SlowTest2.teardown_suite_call_count)  

