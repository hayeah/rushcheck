# = assertion.rb
# this file provides a class Assertion for random testing.

require 'rushcheck/gen'
require 'rushcheck/guard'
require 'rushcheck/property'
require 'rushcheck/result'
require 'rushcheck/testable'

# Assertion class is one of main features of RushCheck.
# You can write a testcase for random testing as follows:
# 
# Assertion.new(Integer, String) do |x, y, g|
#   g.guard { precondition }
#   body
# end
#
# See also documents and several examples.
#
class Assertion
  
  include Testable

  def initialize(*xs, &f)
    @inputs = xs[0..(f.arity - 1)]
    @nguard = f.arity - xs.length 
    @proc = f
  end

  def property
    Property.new(Gen.new do |n, r|
      r2 = r
      @inputs.map do |c|
        r1, r2 = r2.split
        c.arbitrary.value(n, r1)
      end
    end.bind do |args|
      guards = Array.new(@nguard, Guard.new)
      test = begin
               xs = args + guards
               @proc.call(*xs)
             rescue Exception => ex
               case ex
               when RushCheckGuard
                 Result.new(nil)
               else
                 err = "Unexpected exception: #{ex.inspect}\n" + 
                       ex.backtrace.join("\n")
                 Result.new(false, [], [err])
               end
             end
      # not use ensure here because ensure clause
      # does not return values
      test.property.gen.bind do |res|
        res.arguments << args.inspect
        Gen.unit(res)
      end
    end)
  end

end

