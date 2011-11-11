require 'aruba/cucumber'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..')).freeze
TMP_GEM_ROOT = File.join(PROJECT_ROOT, "tmp", "gems")

Before do
  FileUtils.rm_rf(TMP_GEM_ROOT)
  FileUtils.mkdir_p(TMP_GEM_ROOT)
end

ENV["GEM_PATH"] = [TMP_GEM_ROOT, ENV["GEM_PATH"]].join(":")
