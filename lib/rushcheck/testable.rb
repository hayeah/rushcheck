# = testable.rb
# this provides an abstract interface of Testable
# See also QuickCheck in Haskell

require 'rushcheck/config'

module Testable 

  def property
    raise(NotImplementedError, "This method should be overrided.")    
  end

  def check(config=RushCheckConfig.quick)
    config.tests(property.gen, TheStdGen.instance)
  end
  alias quick_check :check
  alias quickcheck  :check

  def classify(p, name)
    p ? label(name) : property
  end

  def imply(p)
    p ? property : Result.nothing.result
  end

  def label(s)
    Property.new(property.gen.fmap {|res| res.stamp << s.to_s; res })
  end
  alias collect :label

  def test
    check(RushCheckConfig.verbose)
  end
  alias verbose_check :test

  def trivial(p)
    classify(p, 'trivial')
  end

end
