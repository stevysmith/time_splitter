$:.push File.expand_path("../lib", __FILE__)
require 'time_splitter/version'

Gem::Specification.new do |s|
  s.name          = "time_splitter"
  s.version       = TimeSplitter::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Michi Huber", "Joshua Kovach"]
  s.email         = ["michi.huber@gmail.com", "kovach.jc@gmail.com"]
  s.homepage      = "https://github.com/shekibobo/time_splitter"
  s.description   = %q{Add split accessors for Date/Time/DateTime objects to easily set the date, time, hour, or minute.}
  s.summary       = %q{Use `datetime_accessor :starts_at` to provide `starts_at_date`, `starts_at_time`, `starts_at_hour`, `starts_at_minute` accessors on the model.}
  s.license       = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'rspec', '~> 3.2'
end
