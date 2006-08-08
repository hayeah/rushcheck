# This file extends the default Ruby's class TrueClass and FalseClass
# for RushCheck.

require 'rushcheck/arbitrary'
require 'rushcheck/integer'
require 'rushcheck/random'
require 'rushcheck/result'
require 'rushcheck/testable'

module RandomBool
  def arbitrary
    Gen.elements([true, false])
  end
  
  def random_range(gen, lo=@@min_bound, hi=@@max_bound)
    v, g = Integer.random_range(gen, 0, 1)
    [v==0, g]
  end
end

class TrueClass

  extend Arbitrary
  extend HsRandom
  extend RandomBool

  include Testable
  include Coarbitrary

  @@min_bound = 0
  @@max_bound = 1

  def self.bound
    [@@min_bound, @@max_bound]
  end

  def coarbitrary(g)
    g.variant(0)
  end

  def property
    Result.new(self).result
  end

end

class FalseClass

  extend Arbitrary
  extend HsRandom
  extend RandomBool

  include Coarbitrary
  include Testable

  @@min_bound = 0
  @@max_bound = 1

  def self.bound
    [@@min_bound, @@max_bound]
  end

  def coarbitrary(g)
    g.variant(1)
  end
  
  def property
    Result.new(self).result
  end
end

class NilClass
  extend Arbitrary

  include Coarbitrary
  include Testable
  
  def self.arbitrary
    Gen.unit(nil)
  end

  def coarbitrary(g)
    g.variant(0)
  end

  def property
    Result.nothing
  end

end
