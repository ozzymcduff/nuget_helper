# NugetHelper

Helper library to simplify the use of nuget in a mixed os environment. It uses [nuget](https://rubygems.org/gems/nuget).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nuget_helper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nuget_helper

## Usage

```ruby
desc "Install missing NuGet packages."
task :install_packages do
  NugetHelper.exec("restore LogViewer.sln")
end
```

To test together with [albacore](https://github.com/Albacore/albacore)

```ruby
desc "test using console"
test_runner :test => [:build] do |runner|
  runner.exe = NugetHelper.nunit_path
  files = Dir.glob(File.join($dir,"*Tests","bin","**","*Tests.dll"))
  runner.files = files 
end
```

## Contributing

1. Fork it ( https://github.com/wallymathieu/nuget_helper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
