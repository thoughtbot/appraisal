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
        gemfile: gemfile.send("gemfile_name"),
        gemfile_path: gemfile.gemfile_path,
        relative_gemfile_path: gemfile.relative_gemfile_path,
      )
    end

    private_class_method :customize
  end
end
