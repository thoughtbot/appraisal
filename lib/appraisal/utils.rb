module Appraisal
  # Contains methods for various operations
  module Utils
    def self.support_parallel_installation?
      Gem::Version.create(Bundler::VERSION) >= Gem::Version.create('1.4.0.pre.1')
    end
  end
end
