# frozen_string_literal: true

RSpec.describe "CLI", "appraisal list" do
  it "prints list of appraisals" do
    build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
      appraise '1.0.0' do
        gem 'dummy', '1.0.0'
      end
      appraise '2.0.0' do
        gem 'dummy', '1.0.0'
      end
      appraise '1.1.0' do
        gem 'dummy', '1.0.0'
      end
    APPRAISAL

    output = run "appraisal list"

    expect(output).to eq("1.0.0\n2.0.0\n1.1.0\n")
  end

  it "prints nothing if there are no appraisals in the file" do
    build_appraisal_file ""
    output = run "appraisal list"

    expect(output.length).to eq(0)
  end
end
