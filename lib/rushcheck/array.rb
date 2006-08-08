# = array.rb
# The file provides a random generator of arrays.

require 'rushcheck/arbitrary'
require 'rushcheck/gen'
require 'rushcheck/testable'

# class RandomArray acts a random generator of arrays.
# Programmer can make a subclass of RandomArray to get
# user defined generators.
class RandomArray < Array

  extend Arbitrary
  include Coarbitrary

  def self.set_pattern(base, &f)
    @@base, @@indp = base, f
  end
  
  def self.arbitrary
    Gen.sized do |m|
      Gen.choose(0..m) do |len|
        if len = 0
        then Gen.unit([])
        else
          Gen.new do |n, r|
            ary = [@@base.arbitrary.value(n, r)]
            r2 = r
            (1..len).each do 
              r1, r2 = r2.split
              ary << @@indp.call(ary).arbitrary.value(n, r1)
            end

            ary
          end
        end
      end
    end
  end

  def coarbitrary(g)
    r = g.variant(0)
    each do |c|
      r = c.coarbitrary(r.variant(1))
    end
    r
  end

end
