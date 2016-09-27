require_relative 'spec_helper'
require "semver"

describe "NuSpec" do
  subject do
    root_folder = File.expand_path(File.join(File.dirname(__FILE__),'nuspecs'))
    NugetHelper::NuSpec.new( File.join(root_folder, "example.nuspec"))
  end

  it 'should have a version' do
    expect(subject.version).to eq SemVer.new(1,2,3)
  end
end

