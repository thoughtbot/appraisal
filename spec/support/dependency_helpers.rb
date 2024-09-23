# frozen_string_literal: true

module DependencyHelpers
  def build_gem(gem_name, version = "1.0.0")
    ENV["GEM_HOME"] = TMP_GEM_ROOT

    unless File.exist? "#{TMP_GEM_ROOT}/gems/#{gem_name}-#{version}"
      FileUtils.mkdir_p "#{TMP_GEM_BUILD}/#{gem_name}/lib"

      FileUtils.cd "#{TMP_GEM_BUILD}/#{gem_name}" do
        gemspec = "#{gem_name}.gemspec"
        lib_file = "lib/#{gem_name}.rb"

        File.open gemspec, "w" do |file|
          file.puts <<-GEMSPEC
            Gem::Specification.new do |s|
              s.name    = #{gem_name.inspect}
              s.version = #{version.inspect}
              s.authors = 'Mr. Smith'
              s.summary = 'summary'
              s.files   = #{lib_file.inspect}
              s.license = 'MIT'
              s.homepage = 'http://github.com/thoughtbot/#{gem_name}'
              s.required_ruby_version = '>= 2.3.0'
            end
          GEMSPEC
        end

        File.open lib_file, "w" do |file|
          file.puts "$#{gem_name}_version = '#{version}'"
        end

        redirect = ENV["VERBOSE"] ? "" : "2>&1"

        puts "building gem: #{gem_name} #{version}" if ENV["VERBOSE"]
        `gem build #{gemspec} #{redirect}`

        puts "installing gem: #{gem_name} #{version}" if ENV["VERBOSE"]
        `gem install -lN #{gem_name}-#{version}.gem -v #{version} #{redirect}`

        puts "" if ENV["VERBOSE"]
      end
    end
  end

  def build_gems(gems)
    gems.each { |gem| build_gem(gem) }
  end

  def build_git_gem(gem_name, version = "1.0.0")
    puts "building git gem: #{gem_name} #{version}" if ENV["VERBOSE"]
    build_gem gem_name, version

    Dir.chdir "#{TMP_GEM_BUILD}/#{gem_name}" do
      `git init . --initial-branch=master`
      `git config user.email "appraisal@thoughtbot.com"`
      `git config user.name "Appraisal"`
      `git add .`
      `git commit --all --no-verify --message "initial commit"`
    end

    # Cleanup Bundler cache path manually for now
    git_cache_path = File.join(ENV["GEM_HOME"], "cache", "bundler", "git")

    Dir[File.join(git_cache_path, "#{gem_name}-*")].each do |path|
      puts "deleting: #{path}" if ENV["VERBOSE"]
      FileUtils.rm_r(path)
    end
  end

  def build_git_gems(gems)
    gems.each { |gem| build_git_gem(gem) }
  end
end
