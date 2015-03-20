require "nuget_helper/version"

module NugetHelper
  def self.os
    @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise "unknown os: #{host_os.inspect}"
      end
    )
  end

  def self.exec(parameters)
    spec = Gem::Specification.find_by_name("nuget")
    command = File.join(spec.gem_dir, "bin", "nuget.exe")
    self.run_tool(command, parameters)
  end

  def self.command_path(library, exe)
    cmds = Dir.glob(File.join("**","packages","#{library}.*","tools",exe))
    if cmds.any?
        command = File.expand_path cmds.first
        return command
    else
      raise "Could not find #{exe} at the packages/#{library}.*/tools/ path!"
    end
  end

  def self.nunit_path
    self.command_path('NUnit.Runners', 'nunit-console.exe')
  end

  def self.xunit_path
    self.command_path('xunit.runners', 'xunit.console.clr4.exe')
  end

  def self.run_tool(command, parameters=nil)
    parameters = '' if parameters.nil?
    if self.os == :windows
      system "#{command} #{parameters}"
    else
      system "mono --runtime=v4.0.30319 #{command} #{parameters} "
    end
  end

  def self.version_of(file)
    file.gsub(/[a-zA-Z]\.?/,'').split(/\./).map do |i| i.to_i end
  end
end
