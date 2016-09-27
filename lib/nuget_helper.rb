require_relative "./nuget_helper/version"
require_relative "./nuget_helper/nuspec"
require "open3"
require "semver"

module NugetHelper
  def self.exec(parameters)
    spec = Gem::Specification.find_by_name("nuget")
    command = File.join(spec.gem_dir, "bin", "nuget.exe")
    self.run_tool(command, parameters)
  end

  def self.command_path(library, exe)
    cmd = self.first_command_path(library, exe)
    if cmd.nil?
      raise "Could not find #{exe} at the packages/#{library}*/tools/ path!"
    end
    return cmd
  end

  def self.nunit_path
    self.command_path('NUnit.Runners', 'nunit-console.exe')
  end

  def self.xunit_clr4_path
    self.command_path('xunit.runners', 'xunit.console.clr4.exe')
  end

  def self.xunit_path
    self.command_path('xunit.runners', 'xunit.console.exe')
  end

  def self.xunit2_path
    self.command_path('xunit.runner.console', 'xunit.console.exe')
  end

  def self.mspec_path
    self.command_path('Machine.Specifications', 'mspec.exe')
  end

  def self.mspec_clr4_path
    self.command_path('Machine.Specifications', 'mspec-clr4.exe')
  end

  def self.nspec_path
    self.command_path('nspec', 'NSpecRunner.exe')
  end

  def self.run_tool(command, parameters=nil)
    system( to_shell_string( command, parameters))
  end

  def self.run_tool_with_result(command, parameters=nil)
    stdout_str, stderr_str, status= Open3.capture3( to_shell_string( command, parameters))
    if ! status.success? 
      raise stderr_str
    end
    stdout_str
  end

  def self.version_of(file)
    SemVer.parse(file.gsub(/^[a-zA-Z]\.?/,'').gsub(/\.nupkg$/, ''))
  end

  def self.last_version(files)
    files.max_by do |l|
      self.version_of(l)
    end
  end

  private
  def self.to_shell_string(command, parameters)
    parameters = '' if parameters.nil?
    if Gem.win_platform? 
      "#{command} #{parameters}"
    else
      "mono --runtime=v4.0 #{command} #{parameters} "
    end
  end
  def self.first_command_path(library, exe)
    cmds = Dir.glob(File.join("**","packages","#{library}*","tools",exe))
    if cmds.any?
      command = File.expand_path cmds.first
      return command
    else
      return nil
    end
  end
end
