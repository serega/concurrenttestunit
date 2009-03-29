
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require "test/unit"
require 'test/unit/concurrent/concurrenttestcase'

require 'setupteardowncounter'

class SlowTest < SetupTeardownCounter
   

  def setup
  end


  def teardown
  end


  def test_one
    sleep(1)
    assert(true)
  end

  def test_two
    sleep(2)
    assert(true)
  end

  def test_three
    sleep(3)
    assert(true)
  end

  def test_four
    sleep(4)
    assert(true)
  end

  def test_five
    sleep(5)
    assert(true)
  end
end

class SlowTest2 < SlowTest
end

class SlowTest3 < SlowTest
end

class SlowTest4 < SlowTest
end