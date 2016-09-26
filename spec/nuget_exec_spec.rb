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
                help = Gem.win_platform? ? "/help" : "-help"
                NugetHelper.run_tool cmd, help
                expect($?.success?).to be true
            end

            it "can run nunit runner and get result" do
                cmd = NugetHelper.nunit_path
                help = Gem.win_platform? ? "/help" : "-help"
                res= NugetHelper.run_tool_with_result cmd, help
                expect(res).not_to be_empty
            end

            it "can run nunit runner and fail" do
                cmd = NugetHelper.nunit_path
                expect { NugetHelper.run_tool_with_result "xxxyyy" }.to raise_error
            end

            it "can run xunit2 runner" do
                cmd = NugetHelper.xunit2_path
                c = NugetHelper.run_tool cmd
                expect(c).to be false
                expect($?.exitstatus).to be 1 
            end

            it "can run xunit clr4 runner" do
                cmd = NugetHelper.xunit_clr4_path
                c = NugetHelper.run_tool cmd
                expect(c).to be false
                #expect($?.exitstatus).to be 1 
            end

            it "can run mspec runner" do
                cmd = NugetHelper.mspec_path
                c = NugetHelper.run_tool cmd
                expect(c).to be false
                expect($?.exitstatus).to be 1 
            end

            it "can run mspec clr4 runner" do
                cmd = NugetHelper.mspec_clr4_path
                c = NugetHelper.run_tool cmd
                expect(c).to be false
                expect($?.exitstatus).to be 1 
            end

            it "can run nspec runner" do
                cmd = NugetHelper.nspec_path
                c = NugetHelper.run_tool cmd
                expect(c).to be true 
                expect($?.exitstatus).to be 0 
            end
        end
    end
end
