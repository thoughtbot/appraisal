require "appraisal/file"
require "yaml"

module Appraisal
  class TravisCIHelper
    NO_CONFIGURATION_WARNING = <<-WARNING.strip
      Note: Run with --travis to generate Travis CI configuration.
    WARNING

    INVALID_CONFIGURATION_WARNING = <<-WARNING.strip.gsub(/\s+/, " ")
      Warning: Your gemfiles directive in .travis.yml is incorrect. Run
      `appraisal generate --travis` to get the correct configuration.
    WARNING

    def self.display_instruction
      puts "# Put this in your .travis.yml"
      puts "gemfiles:"

      File.each do |appraisal|
        puts "  - #{appraisal.relative_gemfile_path}"
      end
    end

    def self.validate_configuration_file
      ConfigurationValidator.new.validate
    end

    class ConfigurationValidator
      CONFIGURATION_FILE = ".travis.yml"

      def validate
        if has_configuration_file?
          if has_no_gemfiles_configuration?
            $stderr.puts(NO_CONFIGURATION_WARNING)
          elsif has_invalid_gemfiles_configuration?
            $stderr.puts(INVALID_CONFIGURATION_WARNING)
          end
        end
      end

      private

      def has_configuration_file?
        ::File.exist?(CONFIGURATION_FILE)
      end

      def has_no_gemfiles_configuration?
        !(configuration && configuration.has_key?("gemfiles"))
      end

      def has_invalid_gemfiles_configuration?
        if configuration && configuration["gemfiles"]
          appraisal_paths =
            File.new.appraisals.map(&:relative_gemfile_path).sort
          travis_gemfile_paths = configuration["gemfiles"].sort
          appraisal_paths != travis_gemfile_paths
        end
      end

      def configuration
        YAML.load_file(CONFIGURATION_FILE) rescue nil
      end
    end
  end
end
