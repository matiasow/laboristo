Gem::Specification.new do |s|
  s.name          = 'laboristo'
  s.version       = '0.4.0'
  s.summary       = 'Simple messages and workers for AWS SQS'
  s.description   = 'A very simple way to handle messages and workers using AWS SQS'
  s.authors       = ['matiasow']
  s.email         = ['matiasow@gmail.com']
  s.homepage      = 'https://github.com/matiasow/laboristo'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.bindir        = 'bin'
  s.executables   << 'laboristo'

  s.add_dependency 'aws-sdk-core', '~> 2'
  s.add_dependency 'clap', '~> 1'

  s.add_development_dependency 'cutest', '~> 1.2'
end
