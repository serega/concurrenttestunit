
require 'test/unit/testsuite'
require 'thread'

require 'test/unit/concurrent/executor'

module Test
module Unit
module Concurrent


class ConcurrentTestSuite < Test::Unit::TestSuite

  MAX_THREADS = 1000

  # Allow to provide executor
  attr_accessor :executor

  # Creates a new TestSuite with the given name.
  def initialize(name)
    super(name)
    @before = lambda {}
    @after = lambda {}
    @executor = nil
  end

  # Runs the tests and/or suites contained in this
  # TestSuite.
  def run(result, &progress_block)
    begin
      yield(STARTED, name)
      needs_shutdown = false
      # If executor is not provided create my own
      if @executor.nil?
        @executor = Executor.new(MAX_THREADS)
        needs_shutdown = true
      end
      begin
        @before.call()
        count_mutex = Mutex.new
        count = @tests.length
        done = ConditionVariable.new
        @tests.each do |test|
          @executor.execute do
            begin
              test.run(result, &progress_block)
            ensure
              count_mutex.synchronize do
                count -= 1
                done.signal
              end
            end
          end
        end
        count_mutex.synchronize { done.wait(count_mutex) until count == 0 }
        @executor.shutdown unless not needs_shutdown
      ensure
        @after.call()
      end
    ensure
      yield(FINISHED, name)
    end
  end



  def before_suite(before)
    @before = before
  end

  def after_suite(after)
    @after = after
  end

end

end # Concurrent
end # Unit
end # Test
