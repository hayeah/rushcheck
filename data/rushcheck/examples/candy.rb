# candy.rb
# an example to write a random generator

require 'rushcheck/rushcheck'

class Candy

  extend Arbitrary

  def initialize(name, price)
    raise unless price >= 0
    @name, @price = name, price
  end

  def self.arbitrary
    xs = [String, Integer].map {|c| c.arbitrary}
    Gen.create(xs) do |name, price, g|
      g.guard { price >= 0 }
      new(name, price)
    end
  end

end

class ExpensiveCandy < Candy

  def initialize(name, price)
    raise unless price >= 100000
    @name, @price = name, price
  end

  def self.arbitrary
    # xs = [String, Integer].map {|c| c.arbitrary}
    lo = 100000
    g = Gen.sized { |n| Gen.choose(lo, n + lo)}
    xs = [String.arbitrary, g]
    Gen.create(xs) do |name, price, g|
      g.guard { price >= 100000 }
      new(name, price)
    end
  end

end
