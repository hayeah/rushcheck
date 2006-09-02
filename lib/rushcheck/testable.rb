# = testable.rb
# this provides an abstract interface of Testable
# See also QuickCheck in Haskell

require 'rushcheck/config'
require 'rushcheck/random'
require 'rushcheck/testresult'

module Testable 

  def property
    raise(NotImplementedError, "This method should be overrided.")    
  end

  def check(config=RushCheckConfig.quick)
    config.tests(property.gen, TheStdGen.instance)
  end
  alias quick_check :check
  alias quickcheck  :check

  def classify(name)
    yield ? label(name) : property
  end

  def imply
    yield ? property : Result.nothing.result
  end

  def label(s)
    Property.new(property.gen.fmap {|res| res.stamp << s.to_s; res })
  end
  alias collect :label

  def run(opts)
    RushCheckConfig.batch(opts.ntests, opts.debug?).
      tests_batch(property, StdGen.new(0))
  end

  def rjustify(n, s)
    ' ' * [0, n - s.length].max + s
  end
  private :rjustify

  def try_test(ts)
    ntests = 1
    count  = 0
    others = []
    if ! ts.empty?
      ts.each do |t|
        begin
          r = t.call(opts)
          case r
          when TestOk
            puts "."
            ntests += 1
            count  += r.ntests
          when TestExausted
            puts "?"
            ntests += 1
            count += r.ntests
          when TestFailed
            puts "#"
            ntests += 1
            others << [r.results, ntests, r.ntests]
            count += r.ntests
          else
            raise(RuntimeError, "RushCheck: illegal result")
          end
        rescue
          puts "*"
          ntests += 1
          next
        end
      end
    end
    print(rjustify([0, 35-ntests].max, " (") + count.to_s + ")\n")
    others
  end
  private :try_test

  def final_run(f, n, no, name)
    puts
    puts "    ** test " + n.to_s + " of " + name + " failed with the binding(s)"
    f.each do |v|
      puts "    **  " + v.to_s
    end
    puts
  end
  private :final_run

  def run_tests(name, opts, tests)
    print(rjustify(25, name) + " : ")
    f = try_test(tests)
    f.each { |f, n, no| final_run(f, n, no, name) }
    nil
  end

  def test
    check(RushCheckConfig.verbose)
  end
  alias verbose_check :test

  def testcase
    Proc.new {|opts| run(opts)}
  end

  def trivial
    classify('trivial') { yield }
  end
end
