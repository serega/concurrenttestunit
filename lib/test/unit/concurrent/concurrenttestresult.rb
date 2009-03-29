

require 'test/unit/testresult'
require 'monitor'


module Test
module Unit
module Concurrent

class ConcurrentTestResult < Test::Unit::TestResult
  def initialize
    super()
    @run_count_lock = Monitor.new
    @failure_lock = Monitor.new
    @error_lock = Monitor.new
    @assertion_count_lock = Monitor.new
  end


  def add_run
    @run_count_lock.synchronize do
      super()
    end
  end


  def add_error(error)
    @error_lock.synchronize do
      super(error)
    end
  end


  def add_assertion
    @assertion_count_lock.synchronize do
      super()
    end
  end

  def add_failure(failure)
    @failure_lock.synchronize do
      super(failure)
    end
  end

end

end # Concurrent
end # Unit
end # Test
  

