When /^I add "([^"]*)" from this project as a dependency$/ do |gem_name|
  append_to_file('Gemfile', %{\ngem "#{gem_name}", :path => "#{PROJECT_ROOT}"})
end

Given /^the following installed dummy gems:$/ do |table|
  table.hashes.each { |hash| build_gem(hash["name"], hash["version"]) }
end

Given /^a git repository exists for gem "(.*?)" with version "(.*?)"$/ do |gem_name, version|
  build_gem(gem_name, version)
  cd gem_name
  run_simple 'git init .'
  run_simple 'git config user.email "appraisal@thoughtbot.com"'
  run_simple 'git config user.name "Appraisal"'
  run_simple 'git add .'
  run_simple 'git commit -a -m "initial commit"'
  dirs.pop
end

Then /^the file "(.*?)" should contain a correct ruby directive$/ do |filename|
  in_current_dir do
    File.read(filename).should match(/^ruby "#{RUBY_VERSION}"$/)
  end
end

Then /^the file "(.*?)" should only include relative paths$/ do |filename|
  in_current_dir do
    File.read(filename).should_not include Dir.pwd
  end
end

When /^I add a relative path to "(.*)"$/ do |filename|
  in_current_dir do
    File.open(filename, "a") { |f| f.write "# relative path: #{Dir.pwd}" }
  end
end
