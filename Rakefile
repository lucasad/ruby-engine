require 'rake/testtask'
require 'rdoc/task'

desc "Run tests"
Rake::TestTask.new do |t|
  t.libs << 'test'
end


desc "Build docs"
RDoc::Task.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

task :default => [:test, :rdoc]
