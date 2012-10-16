module Appraisal
  # Executes commands with a clean environment
  class Command
    BUNDLER_ENV_VARS = %w(RUBYOPT BUNDLE_PATH BUNDLE_BIN_PATH BUNDLE_GEMFILE).freeze

    def self.from_args(gemfile)
      command = ([$0] + ARGV.slice(1, ARGV.size)).join(' ')
      new(command, gemfile)
    end

    def initialize(command, gemfile = nil)
      @original_env = {}
      @gemfile = gemfile
      if command =~ /^bundle/
        @command = command
      else
        @command = "bundle exec #{command}"
      end
    end

    def run
      announce
      with_clean_env do
        unless Kernel.system(@command)
          exit(1)
        end
      end
    end

    def exec
      announce
      with_clean_env { Kernel.exec(@command) }
    end

    private

    def with_clean_env
      unset_bundler_env_vars
      ENV['BUNDLE_GEMFILE'] = @gemfile
      yield
    ensure
      restore_env
    end

    def announce
      if @gemfile
        puts ">> BUNDLE_GEMFILE=#{@gemfile} #{@command}"
      else
        puts ">> #{@command}"
      end
    end

    def unset_bundler_env_vars
      BUNDLER_ENV_VARS.each do |key|
        @original_env[key] = ENV[key]
        ENV[key] = nil
      end
    end

    def restore_env
      @original_env.each { |key, value| ENV[key] = value }
    end
  end
end
