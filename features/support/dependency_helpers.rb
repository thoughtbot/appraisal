module DependencyHelpers
  def build_gem(gem_name, version)
    FileUtils.mkdir_p "tmp/aruba/#{gem_name}/lib"

    FileUtils.cd "tmp/aruba/#{gem_name}" do
      gemspec = "#{gem_name}.gemspec"
      lib_file = "lib/#{gem_name}.rb"

      File.open gemspec, 'w' do |file|
        file.puts <<-gemspec
          Gem::Specification.new do |s|
            s.name    = #{gem_name.inspect}
            s.version = #{version.inspect}
            s.authors = 'Mr. Smith'
            s.summary = 'summary'
            s.files   = #{lib_file.inspect}
          end
        gemspec
      end

      File.open lib_file, 'w' do |file|
        file.puts "$#{gem_name}_version = '#{version}'"
      end

      `gem build #{gemspec} 2>&1`

      ENV['GEM_HOME'] = TMP_GEM_ROOT
      `gem install #{gem_name}-#{version}.gem 2>&1`
    end
  end
end

if respond_to?(:World)
  World(DependencyHelpers)
end
