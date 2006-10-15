# Rakefile for RushCheck
# Do NOT edit Rakefile but edit Rakefile.in!
#

require 'rubygems'
require 'rake'
require 'rake/gempackagetask'

RUSHCHECK_VERSION="0.7"
task :default => ["dist", "gem"]

task :dist do
  system "darcs push -a"
  system "darcs dist -d rushcheck-#{RUSHCHECK_VERSION}"
  system "mv rushcheck-#{RUSHCHECK_VERSION}.tar.gz pkg/"
end

spec = Gem::Specification.new do |s|
  s.name      = 'rushcheck'
  s.summary   = "A lightweight random testing tool"
  s.version   = RUSHCHECK_VERSION
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

task :rdoc do
  Dir.chdir('./lib') do
    system ['rdoc', '-o', '../data/rushcheck/rdoc'].join(' ')
  end
end

task :test_all => Dir.glob("test/spec_*.rb") do |t|
  Dir.chdir('./test') do
    specs = t.prerequisites.map {|f| File.basename f}
    specs.each do |spec|
    raise RuntimeError, "a test is failed" unless system ['spec', spec, '-f', 's', '-c', '-b'].join(' ')
    end
  end
end
