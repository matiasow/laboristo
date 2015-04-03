require 'laboristo/version'

Gem::Specification.new do |s|
  s.name          = 'laboristo'
  s.version       = '0.1.0'
  s.summary       = 'A simple queue client for AWS SQS'
  s.authors       = ['matiasow']
  s.email         = ['matiasow@gmail.com']
  s.homepage      = 'https://github.com/matiasow/laboristo'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.bindir        = 'exe'
  s.executables   << 'laboristo'

  s.add_dependency 'aws-sdk-core', '~> 2'
  s.add_dependency 'clap', '~> 1'

  s.add_development_dependency 'cutest', '~> 1.2'
end
