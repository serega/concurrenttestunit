
require 'test/unit/ui/console/testrunner'
require 'test/unit/ui/testrunnermediator'

require 'test/unit/concurrent/concurrenttestresult'
require 'monitor'

module Test
module Unit
module Concurrent

class ConcurrentTestRunner < Test::Unit::UI::Console::TestRunner



  # Creates a new TestRunner for running the passed
  # suite. If quiet_mode is true, the output while
  # running is limited to progress dots, errors and
  # failures, and the final result. io specifies
  # where runner output should go to; defaults to
  # STDOUT.
  def initialize(suite, output_level=NORMAL, io=STDOUT)
    super(suite, output_level, io)
    @lock = Monitor.new
  end


  def create_mediator(suite)
    mediator = super(suite)
    def mediator.create_result
      return ConcurrentTestResult.new
    end
    return mediator
  end


     
  def add_fault(fault)
    @lock.synchronize { super(fault) }
  end

end

end # Concurrent
end # Unit
end # Test
