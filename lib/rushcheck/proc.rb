# = proc.rb
# The file provides a random generator of procedure.
# See also examples/proc.rb

require 'rushcheck/arbitrary'
require 'rushcheck/gen'
require 'rushcheck/testable'

class RandomProc < Proc

  extend Arbitrary
  include Coarbitrary
  include Testable

  def self.set_pattern(inputs, outputs)
    @@inputs, @@outputs = inputs, outputs
  end

  def self.arbitrary
    Gen.new do |n, r|
      Proc.new do |*args|
        gens = if args.empty?
               then @@outputs.map {|c| c.arbitrary }
               else args.map do |v|
                      @@outputs.map do |c|
                        v.coarbitrary(c.arbitrary)
                      end
                    end.flatten
               end
        Gen.oneof(gens).value(n, r)
      end
    end
  end

  def coarbitrary(g)
    Gen.new do |n, r|
      r2 = r
      args = @@inputs.map do |c| 
        r1, r2 = r2.split
        c.arbitrary.value(n, r1)
      end

      call(*args).coarbitrary(g)
    end
  end

  def property
    Gen.lift_array(@@inputs) {|c| c.arbitrary }.forall do |*args|
      call(*args)
    end
  end

end
