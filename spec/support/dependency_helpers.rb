# frozen_string_literal: true

module DependencyHelpers
  DEFAULT_OPTS = {
    :skip_build => false,
    :skip_install => false,
  }.freeze
  # @param opts [String, Hash] version string, or options hash
  # @option :skip_build [Boolean, nil] skip running gem build, default is false
  # @option :skip_install [Boolean, nil] skip running gem install, default is value of skip_build
  # @option :version [String, nil] version for the gem, default is "1.0.0"
  # @return void
  def build_gem(gem_name, opts = {})
    ENV["GEM_HOME"] = TMP_GEM_ROOT
    version = "1.0.0" # default

    if opts.respond_to?(:has_key?)
      version = opts[:version] if opts.has_key?(:version)
      opts[:skip_build] = false unless opts.has_key?(:skip_build)
      opts[:skip_install] = opts[:skip_build] unless opts.has_key?(:skip_install)
    else
      version = case opts
      when String then opts
      when nil then "1.0.0"
      else
        raise ArgumentError, "Unexpected value for opts (must be version string or options Hash): #{opts}"
      end
      opts = DEFAULT_OPTS.dup
    end
    skip_build = opts[:skip_build]
    skip_install = opts[:skip_install]
    return if File.exist? "#{TMP_GEM_ROOT}/gems/#{gem_name}-#{version}"

    build_dir = "#{TMP_GEM_BUILD}/#{gem_name}"
    FileUtils.mkdir_p "#{build_dir}/lib"

    FileUtils.cd build_dir do
      gemspec = "#{gem_name}.gemspec"
      lib_file = "lib/#{gem_name}.rb"

      File.open gemspec, "w" do |file|
        file.puts <<-GEMSPEC.strip_heredoc.rstrip
          Gem::Specification.new do |s|
            s.name    = #{gem_name.inspect}
            s.version = #{version.inspect}
            s.authors = 'Mr. Smith'
            s.summary = 'summary'
            s.files   = #{lib_file.inspect}
            s.license = 'MIT'
            s.homepage = 'http://github.com/thoughtbot/#{gem_name}'
            s.required_ruby_version = '>= 1.8.7'
          end
        GEMSPEC
      end

      File.open lib_file, "w" do |file|
        file.puts "$#{gem_name}_version = '#{version}'"
      end

      redirect = ENV["VERBOSE"] ? "" : "2>&1"

      # Caller may turn it into a git repo here
      yield build_dir, redirect if block_given?

      unless skip_build
        puts "building gem: #{gem_name} #{version}" if ENV["VERBOSE"]
        %x(gem build #{gemspec} #{redirect})
      end

      unless skip_install
        puts "installing gem: #{gem_name} #{version}" if ENV["VERBOSE"]
        %x(gem install -lN #{gem_name}-#{version}.gem -v #{version} #{redirect})
      end

      puts "" if ENV["VERBOSE"]
    end

    nil
  end

  def build_gems(gems)
    gems.each { |gem| build_gem(gem) }
  end

  def build_git_gem(gem_name, version = "1.0.0")
    build_gem(gem_name, {:version => version, :skip_build => true, :skip_install => true}) do |_gem_dir, redirect|
      # At this point we have a gem file structure on disk inside `_gem_dir`.
      # Since we are already inside _gem_dir, we do not need to chdir.
      puts "initializing git repo for gem: #{gem_name} #{version}" if ENV["VERBOSE"]
      # Set up our clone of the bare git repository, and push our gem into it
      %x(git init . --initial-branch=main #{redirect})
      %x(git config user.email "appraisal@thoughtbot.com" #{redirect})
      %x(git config user.name "Appraisal" #{redirect})
      %x(git config commit.gpgsign false #{redirect})
      %x(git add . #{redirect})
      %x(git commit --all --no-verify --message "initial commit" #{redirect})
    end

    # Cleanup Bundler cache path manually for now
    git_cache_path = File.join(ENV["GEM_HOME"], "cache", "bundler", "git")

    Dir[File.join(git_cache_path, "#{gem_name}-*")].each do |path|
      puts "cleaning up bundler git cache: #{path}" if ENV["VERBOSE"]
      FileUtils.rm_r(path)
    end
  end

  def build_git_gems(gems)
    gems.each { |gem| build_git_gem(gem) }
  end
end
