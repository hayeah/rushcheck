# = Config.rb
# This file is implemented for the class RushCheckConfig.

# RushCheckConfig is a class which has configurations of tests.
# This class is needed for several test functions.
class RushCheckConfig

  attr_reader :max_test, :max_fail, :size, :every

  def self.quick
    new(100, 1000, 
        Proc.new{|x| x / 2 + 3},
        Proc.new do |n, args|
          s = n.to_s
          s + ("\b" * s.length)
        end)
  end

  def self.verbose 
    new(100, 1000, 
        Proc.new{|x| x / 2 + 3},
        Proc.new do |n, args|
          n.to_s + ":\n" + args.join("\n") + "\n"
        end)
  end

  def initialize(max_test, max_fail, size, every)
    @max_test, @max_fail, @size, @every = max_test, max_fail, size, every
  end

  # print results of tests.
  def done(mesg, ntest, stamps)
    print mesg + ' ' + ntest.to_s + ' tests'

    bag = stamps.compact.find_all {|x| ! x.empty?}.sort.
            inject(Hash.new) do |r, m|
              r[m] = r[m].nil? ? 1 : r[m] + 1
              r
            end.sort_by {|k, v| v}.reverse.map do |pair|
              percentage = ((100 * pair[1]) / ntest).to_s + '%'
              ([percentage] + pair[0]).join(', ')
            end

    mes = case bag.length
          when 0
            ".\n"
          when 1
            '(' + bag[0] + ").\n"
          else
            ".\n" + bag.join(".\n") + ".\n"
          end

    print mes
  end

  # execute tests
  def tests(gen, rnd, nt=1, nf=0, stamps=[])
    ntest, nfail = nt, nf
    while true
      if ntest > max_test
        done('OK, passed', max_test, stamps)
        tests_result = true
        break
      end
      if nfail > max_fail
        done('Arguments exhausted after ', ntest, stamps)
        tests_result = nil
        break
      end

      rnd_l, rnd_r = rnd.split
      result = gen.generate(size.call(ntest), rnd_r)
      message = every.call(ntest, result.arguments)
      print message # don't puts

      case result.ok
      when nil
        nfail += 1
        redo
      when true
        stamps.push(result.stamp)
        ntest += 1
        redo
      when false
        error = "Falsifiable, after " + ntest.to_s + " tests:\n" + 
          result.arguments.join("\n")
        puts error
        tests_result = false
        break
      else
        raise(RuntimeError, "RushCheck: illegal result")
      end
    end
    
    tests_result
  end

end
