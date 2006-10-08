# This example is quoted from the RSpec tutorial.
# check also http://rspec.rubyforge.org/tutorials/index.html

class Stack

  def initialize
    @stack = []
  end
  
  def empty?
    @stack.empty?
  end

  def push(item)
    @stack.push item
  end

end
