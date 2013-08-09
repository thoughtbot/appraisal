require 'spec_helper'

describe 'CLI' do
  context 'appraisal (with no arguments)' do
    it 'runs install command' do
      build_appraisal_file <<-Appraisal
        appraise '1.0.0' do
          gem 'dummy', '1.0.0'
        end
      Appraisal

      run_simple 'appraisal'

      expect(file 'gemfiles/1.0.0.gemfile').to be_exists
      expect(file 'gemfiles/1.0.0.gemfile.lock').to be_exists
    end
  end

  context 'appraisal (with arguments)' do
    before do
      build_appraisal_file <<-Appraisal
        appraise '1.0.0' do
          gem 'dummy', '1.0.0'
        end

        appraise '1.1.0' do
          gem 'dummy', '1.1.0'
        end
      Appraisal

      run_simple 'appraisal install'
      write_file 'test.rb', 'puts "Running: #{$dummy_version}"'
    end

    context 'with appraisal name' do
      it 'runs the given command against a correct versions of dependency' do
        test_command = 'appraisal 1.0.0 ruby -rbundler/setup -rdummy test.rb'
        run_simple test_command

        expect(output_from test_command).to include 'Running: 1.0.0'
        expect(output_from test_command).to_not include 'Running: 1.1.0'
      end
    end

    context 'without appraisal name' do
      it 'runs the given command against all versions of dependency' do
        test_command = 'appraisal ruby -rbundler/setup -rdummy test.rb'
        run_simple test_command

        expect(output_from test_command).to include 'Running: 1.0.0'
        expect(output_from test_command).to include 'Running: 1.1.0'
      end
    end
  end

  context 'appraisal generate' do
    it 'generates the gemfiles' do
      build_appraisal_file <<-Appraisal
        appraise '1.0.0' do
          gem 'dummy', '1.0.0'
        end

        appraise '1.1.0' do
          gem 'dummy', '1.1.0'
        end
      Appraisal

      run_simple 'appraisal generate'

      expect(file 'gemfiles/1.0.0.gemfile').to be_exists
      expect(file 'gemfiles/1.1.0.gemfile').to be_exists
      expect(content_of 'gemfiles/1.0.0.gemfile').to eq <<-gemfile.strip_heredoc
        # This file was generated by Appraisal

        source "https://rubygems.org"

        gem "appraisal", :path=>"#{PROJECT_ROOT}"
        gem "dummy", "1.0.0"
      gemfile
    end
  end

  context 'appraisal install' do
    it 'installs the dependencies' do
      build_appraisal_file <<-Appraisal
        appraise '1.0.0' do
          gem 'dummy', '1.0.0'
        end

        appraise '1.1.0' do
          gem 'dummy', '1.1.0'
        end
      Appraisal

      run_simple 'appraisal install'

      expect(file 'gemfiles/1.0.0.gemfile.lock').to be_exists
      expect(file 'gemfiles/1.1.0.gemfile.lock').to be_exists
    end

    it 'relativize directory in gemfile.lock' do
      build_gemspec
      add_gemspec_to_gemfile
      build_appraisal_file <<-Appraisal
        appraise '1.0.0' do
          gem 'dummy', '1.0.0'
        end
      Appraisal

      run_simple 'appraisal install'

      expect(content_of 'gemfiles/1.0.0.gemfile.lock').not_to include current_dir
    end
  end

  context 'appraisal clean' do
    it 'remove all gemfiles from gemfiles directory' do
      build_appraisal_file <<-Appraisal
        appraise '1.0.0' do
          gem 'dummy', '1.0.0'
        end
      Appraisal

      run_simple 'appraisal install'
      write_file 'gemfiles/non_related_file', ''

      run_simple 'appraisal clean'

      expect(file 'gemfiles/1.0.0.gemfile').not_to be_exists
      expect(file 'gemfiles/1.0.0.gemfile.lock').not_to be_exists
      expect(file 'gemfiles/non_related_file').to be_exists
    end
  end
end
