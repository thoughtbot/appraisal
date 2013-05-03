When /^I add "([^"]*)" from this project as a dependency$/ do |gem_name|
  append_to_file('Gemfile', %{\ngem "#{gem_name}", :path => "#{PROJECT_ROOT}"})
end

Given /^the following installed dummy gems:$/ do |table|
  table.hashes.each { |hash| build_gem(hash["name"], hash["version"]) }
end

Given /^a git repository exists for gem "(.*?)" with version "(.*?)"$/ do |gem_name, version|
  build_gem(gem_name, version)
  cd gem_name
  in_current_dir { `git init . && git add . && git commit -a -m 'initial commit'` }
  dirs.pop
end

Then /^the file "(.*?)" should contain a correct ruby directive$/ do |filename|
  in_current_dir do
    File.read(filename).should match(/^ruby "#{RUBY_VERSION}"$/)
  end
end
