require "bundler/gem_tasks"
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
    t.libs.push "lib"
    t.test_files = FileList['test/**/*.rb']
    t.verbose = true
end

task :fixdates do
    branch = `git branch --no-color -r --merged`.strip
    `git fix-dates #{branch}..HEAD`
end

task :fixdates_f do
    branch = `git branch --no-color -r --merged`.strip
    `git fix-dates -f #{branch}..HEAD`
end

task :trim_whitespace do
  system(%Q[git status --short | awk '{if ($1 != "D" && $1 != "R") print $2}' | grep -e '.*\.rb$' | xargs sed -i '' -e 's/[ \t]*$//g;'])
end
