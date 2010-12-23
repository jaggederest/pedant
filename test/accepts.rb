require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/pedant')

class AcceptsTest < Test::Unit::TestCase
  def setup
    @bar = Bar.new
  end

  def test_accepts
    assert_nothing_raised { @bar.should_succeed(1) }
    assert_raise(Pedant::TypeError) { @bar.should_fail(1) }
  end

  def test_user_guard
    assert_nothing_raised { @bar.small_int(1) }
    assert_raise(Pedant::GuardError) { @bar.small_int_fail(100) }
    assert_nothing_raised { @bar.guard_only(1) }
  end

  def test_class_method
    assert_nothing_raised { Bar.should_succeed!(1) }
  end
end

class Bar
  include Pedant::Accepts
  def should_fail(val)
    :should_fail
  end
  def should_succeed(val)
    :lololololo
  end
  accepts(:should_fail, String)
  accepts(:should_succeed, Numeric)

  def small_int(val)
    5
  end

  accepts(:small_int, Integer) {|val| val < 10 }

  def small_int_fail(val)
    100
  end
  accepts(:small_int_fail, Integer) {|val| val < 10 }

  def guard_only(val)
    'foo'
  end
  accepts(:guard_only) {|val| val != 'whee' }

  class << self
    def should_succeed!(val)
      :foo
    end
    accepts(:should_succeed!, Numeric)
  end
end
