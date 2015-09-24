require_relative 'spec_helper'

describe "NugetHelper" do
    describe "with restored packages" do
        let(:xunit_versions) do
            ["xunit.runners.1.9.3","xunit.runners.1.9.2","xunit.runners.1.9.1"]
        end
        let(:nunit_versions) do
            ["nunit.runners.2.6.1","nunit.runners.2.6.4","nunit.runners.2.3.6","nunit.runners.1.9.1"]
        end


        it "can find latest xunit" do
            xunit = xunit_versions.sort_by do |xunit| NugetHelper.version_of xunit end.last
            expect(xunit).to eq 'xunit.runners.1.9.3'
        end
        it "can find latest nunit" do
            xunit = nunit_versions.sort_by do |nunit| NugetHelper.version_of nunit end.last
            expect(xunit).to eq 'nunit.runners.2.6.4'
        end

        it "can parse out version" do
            expect( NugetHelper.version_of 'somelib.something.35.63.7').to eq [35,63,7]
        end

        it "can determine latest version of" do
            expect( NugetHelper.last_version ['With.0.4.7.nupkg','With.1.0.2.nupkg','With.1.0.1.nupkg']).to eq 'With.1.0.2.nupkg'
        end
    end
end