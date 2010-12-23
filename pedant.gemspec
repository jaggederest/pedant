spec = Gem::Specification.new do |s|
  s.name = 'pedant'
  s.version = '0.6'
  s.summary = 'Pedant: Enforcing return values... annoying yet handy!'
  s.description = 'In defining your classes, you can define allowable return values for your methods by type and with user-defined guards.'
  s.license = 'MIT'
  s.files = ['lib/pedant.rb']
  s.extra_rdoc_files = ['README.rdoc']
  s.test_files = Dir.glob('test/*.rb')
  s.require_path = 'lib'
  s.authors = ['Jared Kuolt', 'Justin George']
  s.email = ['me@superjared.com', 'justin.george@gmail.com']
  s.homepage = 'http://github.com/jaggederest/pedant/tree/master'
end
