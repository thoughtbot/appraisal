# frozen_string_literal: true

module Appraisal
  class Customize
    def initialize(heading: nil, single_quotes: false)
      @@heading = heading&.chomp
      @@single_quotes = single_quotes
    end

    def self.heading(gemfile)
      @@heading ||= nil
      customize(@@heading, gemfile)
    end

    def self.single_quotes
      @@single_quotes ||= false
    end

    def self.customize(heading, gemfile)
      return nil unless heading

      format(
        heading.to_s,
        appraisal: gemfile.send("clean_name"),
        gemfile: gemfile.send("gemfile_name"),
        gemfile_path: gemfile.gemfile_path,
        lockfile: "#{gemfile.send('gemfile_name')}.lock",
        lockfile_path: gemfile.send("lockfile_path"),
        relative_gemfile_path: gemfile.relative_gemfile_path,
        relative_lockfile_path: "#{gemfile.relative_gemfile_path}.lock"
      )
    end

    private_class_method :customize
  end
end
