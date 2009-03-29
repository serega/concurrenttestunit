

require 'test/unit/testcase'


require 'test/unit/concurrent/concurrenttestsuite'
require 'monitor'


module Test
module Unit 
module Concurrent


class ConcurrentTestCase < Test::Unit::TestCase

  def initialize(test_method_name, setup_lock, teardown_lock)
    super(test_method_name)
    @setup_lock = setup_lock
    @teardown_lock = teardown_lock
  end


  # Will be called once before running a suite.
  def setup_suite
  end

  # Will be called once after all tests withing suite have finished.
  def teardown_suite
  end



  
  def self.suite
    method_names = public_instance_methods(true)
    tests = method_names.delete_if {|method_name| method_name !~ /^test./}
    suite = ConcurrentTestSuite.new(name)
    suite.before_suite(lambda { new(:setup_suite, nil, nil).setup_suite  })
    suite.after_suite(lambda { new(:teardown_suite, nil, nil).teardown_suite })
    setup_lock = Monitor.new
    teardown_lock = Monitor.new
    tests.sort.each do
    |test|
      catch(:invalid_test) do
        suite << new(test, setup_lock, teardown_lock)
      end
    end
    if (suite.empty?)
      catch(:invalid_test) do
        suite << new("default_test", setup_lock, teardown_lock)
      end
    end
    return suite
  end


  # Copy/Paste from super. Just setup/teardown are syncronized
  def run(result)
    yield(STARTED, name)
    @_result = result
    begin
      @setup_lock.synchronize { setup() }
      __send__(@method_name)
    rescue Test::Unit::AssertionFailedError => e
      add_failure(e.message, e.backtrace)
    rescue Exception
      raise if PASSTHROUGH_EXCEPTIONS.include? $!.class
      add_error($!)
    ensure
      begin
        @teardown_lock.synchronize { teardown() }
      rescue Test::Unit::AssertionFailedError => e
        add_failure(e.message, e.backtrace)
      rescue Exception
        raise if PASSTHROUGH_EXCEPTIONS.include? $!.class
        add_error($!)
      end
    end
    result.add_run
    yield(FINISHED, name)
  end

end

end # Concurrent
end # Unit
end # Test

