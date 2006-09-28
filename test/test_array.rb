require 'test/unit'
require 'rushcheck'

class TC_RandomArray < Test::Unit::TestCase

  class MyRandomArray < RandomArray; end
  def setup
    MyRandomArray.set_pattern(0) {|i| i}
  end

  def teardown
  end

  class TestBaseArray < RandomArray; end
  def test_set_pattern_base
    RushCheck::Assertion.new(Integer, Integer, Integer) do |x, i, n, g|
      g.guard {i > 0}
      TestBaseArray.set_pattern(x) {|j| nil}
      a = TestBaseArray.arbitrary.value(n, RushCheck::StdGen.new)
      a.empty? || (a.first == x && a[i].nil?)
    end.quick_check
  end

  def test_arbitrary
    assert_instance_of(RushCheck::Gen, MyRandomArray.arbitrary)
  end

  def test_coarbitrary
    g = RushCheck::Gen.unit(0)
    assert_instance_of(RushCheck::Gen, MyRandomArray.new.coarbitrary(g))
  end

end
