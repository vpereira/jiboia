require 'rake/testtask'

Rake::TestTask.new do |t|
    t.libs.push "lib"
    t.libs.push "specs"
    t.test_files = FileList['specs/*_spec.rb']
    t.verbose = true
end
