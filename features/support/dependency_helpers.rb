module DependencyHelpers
  def build_gem(name, version)
    create_dir(name)
    cd(name)
    create_dir("lib")
    gem_path = "#{name}.gemspec"
    version_path = "lib/#{name}.rb"
    spec = <<-SPEC
      Gem::Specification.new do |s|
        s.name    = '#{name}'
        s.version = '#{version}'
        s.authors = 'Mr. Smith'
        s.summary = 'summary'
        s.files   = '#{version_path}'
      end
    SPEC
    write_file(gem_path, spec)
    write_file(version_path, "$#{name}_version = '#{version}'")
    in_current_dir { `gem build #{gem_path} 2>&1` }
    set_env("GEM_HOME", TMP_GEM_ROOT)
    in_current_dir { `gem install #{name}-#{version}.gem 2>&1` }
    FileUtils.rm_rf(File.join(current_dir, name))
    dirs.pop
  end
end

if respond_to?(:World)
  World(DependencyHelpers)
end
