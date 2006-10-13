# Rakefile for RushCheck
#
#

require 'rubygems'
require 'rake'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name      = 'rushcheck'
  s.summary   = "A lightweight random testing tool"
  s.version   = "0.6"
  s.author    = 'Daisuke IKEGAMI'
  s.email     = 'ikegami@madscientist.jp'
  s.homepage  = 'http://rushcheck.rubyforge.org'
  s.platform  = Gem::Platform::RUBY
  
  s.has_rdoc  = true
  # s.test_file = 

  s.require_path = 'lib'
  s.autorequire  = 'rushcheck'
  s.bindir       = 'bin'
  # s.executable = 
  # s.extra_rdoc_files = 
  s.files = FileList['lib/**/*', 'data/**/**/*', 
                     '[A-Z]*', 'copying.txt'].to_a
  s.description = <<-EOF
    RushCheck is a random testing tool which is one of implementations
    of QuichCheck in Haskell.
  EOF
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
