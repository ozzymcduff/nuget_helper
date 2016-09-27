require "nokogiri"
require "semver"
module NugetHelper
  class NuSpec
    attr_reader :nuspec_path_base, :nuspec_filename, :nuspec_xml_node

    def initialize nuspec_path
      raise ArgumentError, 'nuspec path does not exist' unless File.exists? nuspec_path.to_s
      nuspec_path = nuspec_path.to_s unless nuspec_path.is_a? String
      @nuspec_xml_node = Nokogiri.XML(open(nuspec_path))
      @nuspec_path_base, @nuspec_filename = File.split nuspec_path
    end
    def version
      el = @nuspec_xml_node.xpath("/package/metadata/version")
      SemVer.parse(el.text)
    end
  end
end