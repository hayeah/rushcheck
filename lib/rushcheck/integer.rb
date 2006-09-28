# = integer.rb
# an extension to Integer class for RushCheck
#

require 'rushcheck/arbitrary'
require 'rushcheck/gen'
require 'rushcheck/random'

# ruby's Integer class is extended to use RushCheck library.
# See also HsRandom, Arbitrary and Coarbitrary.
class Integer
  extend HsRandom
  extend Arbitrary
  include Coarbitrary

  @@max_bound =  2**30 - 1
  @@min_bound = -(2**30)

  # this method is needed to include HsRandom.
  def self.bound
    [@@min_bound, @@max_bound]
  end

  # this method is needed to use Arbitrary.
  def self.arbitrary
    Gen.sized {|n| Gen.choose(-n, n) }
  end

  # this method is needed to include HsRandom.
  def self.random_range(gen, lo=@@min_bound, hi=@@max_bound)
    hi, lo = lo, hi if hi < lo 
    v, g = gen.gen_next
    d = hi - lo + 1

    if d == 1
    then [lo, g]
    else [(v % d) + lo, g]
    end
  end

  # this method is needed to use Coarbitrary.
  def coarbitrary(g)
    m = (self >= 0) ? 2 * self  : (-2) * self + 1
    g.variant(m)
  end

end
