# This example is quoted from the RSpec tutorial.
# check also http://rspec.rubyforge.org/tutorials/index.html
#
# To execute this example, you have to follow
# 1. install rspec
#    % sudo gem install rspec
# 2. then, execute the 'spec' command
#    % spec stack_spec.rb -f s

begin
  require 'rubygems'
  require_gem 'rushcheck'
  rescue
  require 'rushcheck'
end

def forall(*cs, &f)
  RushCheck::Assertion.new(*cs) {|*xs| f.call(xs); true}.check
end

require 'stack'

context "A new stack" do
  setup do
    @stack = Stack.new
  end
  specify "should be empty" do
    @stack.should_be_empty
  end
end

context "An empty stack" do
  setup do
    @stack = Stack.new
  end
  specify "should not be empty after 'push'" do
    forall(Integer) do |item|
      @stack.push item
      @stack.should_not_be_empty
    end
  end
end
