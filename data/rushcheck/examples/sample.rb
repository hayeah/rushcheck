# a simple example

require 'rushcheck/rushcheck'

# first boring example
def assert_sort
  Assertion.new { [].sort == [] }.check
end

# assert_sort_one should be true
def assert_sort_one
  Assertion.new(Integer) { |x|
    [x].sort == [x]
  }.check
end

# however, assert_sort_two is not true generally,
# and RushCheck finds a counter example.
def assert_sort_two
  Assertion.new(Integer, Integer) { |x, y|
    ary = [x, y]
    ary.sort == ary
  }.check
end

# if given array is already sorted, then the
# assertion turns true.
def assert_sort_two_sorted
  Assertion.new(Integer, Integer) { |x, y, g|
    g.guard {x <= y}
    ary = [x, y]
    ary.sort == ary
  }.check
end

# watch statistics 
def assert_sort_two_sorted_trivial
  Assertion.new(Integer, Integer) { |x, y, g|
    g.guard {x <= y}
    ary = [x, y]
    (ary.sort == ary).trivial{x == y}
  }.check
end

def assert_sort_two_sorted_classify
  Assertion.new(Integer, Integer) { |x, y, g|
    g.guard {x <= y}
    ary = [x, y]
    (ary.sort == ary).classify('same'){x == y}.
      classify('bit diff') { (x - y).abs == 1 }
  }.check
end
