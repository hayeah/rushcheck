# = property.rb
# This file defines properties of testcase
# class Property is used for RushCheck internally
require 'rushcheck/gen'
require 'rushcheck/result'
require 'rushcheck/testable'

class Property

  include Testable

  attr_reader :gen
  def initialize(obj=nil, stamp=[], arguments=[])
    case obj
    when nil, true, false
      result = Result.new(obj, stamp, arguments)
      @gen    = Gen.unit(result)
    when Gen
      @gen = obj
    else
      raise(RuntimeError, "illegal arguments")
    end
  end

  def property
    self
  end

end
