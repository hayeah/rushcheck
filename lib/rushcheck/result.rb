# = result.rb
# This file defines results of testcase
# class Result is used for RushCheck internally

require 'rushcheck/property'
require 'rushcheck/testable'

class Result

  include Testable

  def self.nothing
    Result.new(false)
  end

  attr_reader :ok, :stamp, :arguments
  def initialize(ok=nil, stamp=[], arguments=[])
    @ok, @stamp, @arguments = ok, stamp, arguments
  end

  def result
    Property.new(@ok, @stamp, @arguments)
  end
  alias property :result

end
