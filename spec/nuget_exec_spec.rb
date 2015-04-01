require_relative 'spec_helper'
$vs_2013_solution = File.join(File.dirname(__FILE__), "Vs2013Solution", "Vs2013Solution.sln")

describe "NugetHelper" do
     describe "execute system nuget" do
        it "can restore packages" do
            NugetHelper.exec("restore #{$vs_2013_solution}")
        end

        describe "with restored packages" do
            before(:all) do
                NugetHelper.exec("restore #{$vs_2013_solution}")
            end

            it "can run nunit runner" do
                cmd = NugetHelper.nunit_path
                help = NugetHelper.os != :windows ? "-help" : "/help"
                NugetHelper.run_tool cmd, help
                expect($?.success?).to be true
            end

            it "can run xunit runner" do
                cmd = NugetHelper.xunit_path
                c = NugetHelper.run_tool cmd
                expect(c).to be false
                expect($?.exitstatus).to be 1 
            end
        end
    end
end
