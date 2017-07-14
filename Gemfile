source 'https://rubygems.org'

# Find a location or specific version for a gem. place_or_version can be a
# version, which is most often used. It can also be git, which is specified as
# `git://somewhere.git#branch`. You can also use a file source location, which
# is specified as `file://some/location/on/disk`.
def location_for(place_or_version, fake_version = nil)
  if place_or_version =~ /^(git[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place_or_version =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place_or_version, { :require => false }]
  end
end

supports_windows = false

gem 'puppet', *location_for(ENV['PUPPET_GEM_VERSION'])
gem 'puppet-lint'
gem 'puppetlabs_spec_helper'
gem 'github_changelog_generator'
gem 'rspec-puppet'
gem 'rspec-puppet-facts'
gem 'rspec-puppet-utils'
gem 'metadata-json-lint'
