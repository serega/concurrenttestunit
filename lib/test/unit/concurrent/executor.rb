
module Test
module Unit
module Concurrent


if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
  require 'java'

  class Executor
    def initialize(max_size)
      @executor = java.util.concurrent.Executors.newFixedThreadPool(max_size)
    end

    def execute(*args)
      @executor.execute { yield(*args) }
    end

    def shutdown
      @executor.shutdown
    end
  end

else
  require 'thread'
  class Executor
     def initialize(max_size)
       @pool = []
       @max_size = max_size
       @pool_mutex = Mutex.new
       @pool_cv = ConditionVariable.new
     end

     def execute(*args)
       Thread.new do
         @pool_mutex.synchronize do
           while @pool.size >= @max_size
             @pool_cv.wait(@pool_mutex)
           end
           @pool << Thread.current
         end

         begin
           yield(*args)
         ensure
           @pool_mutex.synchronize do
             @pool.delete(Thread.current)
             @pool_cv.signal
           end
         end
       end
     end

     def shutdown
       @pool_mutex.synchronize { @pool_cv.wait(@pool_mutex) until @pool.empty? }
     end
   end
end


end # Concurrent
end # Unit
end # Test
