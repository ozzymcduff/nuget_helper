require_relative "./nuget_helper/version"
require_relative "./nuget_helper/nuspec"
require "open3"
require "xsemver"
require "tmpdir"
require "fileutils"
require "securerandom"
module NugetHelper
  include XSemVer

  def self.exec(parameters)
    spec = Gem::Specification.find_by_name("nuget")
    command = File.join(spec.gem_dir, "bin", "nuget.exe")
    self.run_tool(command, parameters)
  end

  def self.magnitude_next_nuget_version(package_name, next_dll)
    begin
      tmp = File.join(Dir.tmpdir, SecureRandom.hex)
      self.exec("install '#{package_name}' -o #{tmp}")
      orig = Dir.glob( File.join(tmp, "**", File.basename(next_dll)) ).first
      path_to_package = Dir.glob( File.join(tmp, "*") ).first 
      v = SemVer.parse(path_to_package)
      m = self.run_tool_with_result(self.semver_fromassembly_path, " --magnitude #{orig} #{next_dll}").strip
      case m
      when 'Patch'
        v.patch += 1
        [:patch, v]
      when 'Major'
        v.major += 1
        [:major, v]
      when 'Minor'
        v.minor += 1
        [:minor, v]
      end
    ensure
      FileUtils.rm_rf(tmp)
    end
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

  def self.semver_fromassembly_path
    self.command_path('SemVer.FromAssembly', 'SemVer.FromAssembly.exe')
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
    SemVer.parse(file.gsub(/\.nupkg$/, ''))
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
