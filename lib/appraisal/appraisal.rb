require 'appraisal/gemfile'
require 'appraisal/command'
require 'fileutils'

module Appraisal
  # Represents one appraisal and its dependencies
  class Appraisal
    attr_reader :name, :gemfile

    def initialize(name, source_gemfile)
      @name = name
      @gemfile = source_gemfile.dup
    end

    def gem(name, *requirements)
      gemfile.gem(name, *requirements)
    end

    def write_gemfile
      ::File.open(gemfile_path, "w") do |file|
        file.puts("# This file was generated by Appraisal")
        file.puts
        file.write(gemfile.to_s)
      end
    end

    def install
      Command.new(bundle_command).run
    end

    def cruise
      Command.new(cruise_command).run
    end

    def gemfile_path
      unless ::File.exist?(gemfile_root)
        FileUtils.mkdir(gemfile_root)
      end

      ::File.join(gemfile_root, "#{clean_name}.gemfile")
    end

    def bundle_command
      "bundle install --gemfile='#{gemfile_path}'"
    end

    def cruise_command
      gemfile = "--gemfile='#{gemfile_path}'"
      "bundle check #{gemfile} || bundle install #{gemfile} || (rm #{gemfile_path}.lock && bundle install #{gemfile})"
    end

    private

    def gemfile_root
      ::File.join(Dir.pwd, "gemfiles")
    end

    def clean_name
      name.gsub(/\s+/, '_').gsub(/[^\w]/, '')
    end
  end
end

