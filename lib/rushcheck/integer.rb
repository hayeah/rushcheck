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
    raise(RuntimeError, "illegal arguments:#{lo}, #{hi}") if hi - lo + 1 == 0
    v, g = gen.gen_next

    [(v % (hi - lo + 1)) + lo, g]
  end

  # this method is needed to use Coarbitrary.
  def coarbitrary(g)
    m = (self >= 0) ? 2 * self  : (-2) * self + 1
    g.variant(m)
  end

end
