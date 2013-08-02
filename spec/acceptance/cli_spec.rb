require 'spec_helper'

describe 'CLI', 'generate' do
  it 'generates the gemfiles' do
    build_gem 'dummy', '1.0.0'
    build_gem 'dummy', '1.1.0'
    build_appraisal_file <<-Appraisal.strip_heredoc
      appraise '1.0.0' do
        gem 'dummy', '1.1.0'
      end

      appraise '1.1.1' do
        gem 'dummy', '1.1.0'
      end
    Appraisal

    run_simple 'appraisal generate'

    expect_file('gemfiles/1.0.0.gemfile').to be_exists
    expect_file('gemfiles/1.1.0.gemfile').to be_exists
    expect_file('gemfiles/1.0.0.gemfile').content.to eq <<-gemfile.strip_heredoc
      source 'https://rubygems.org'

      gem 'dummy', '1.0.0'
    gemfile
  end
end
