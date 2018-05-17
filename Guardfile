# frozen_string_literal: true

guard :rspec, cmd: 'bin/bundle exec spring rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  watch(rails.controllers) do |m|
    [
      rspec.spec.call("controllers/#{m[1]}"),
      rspec.spec.call("requests/#{m[1]}")
    ]
  end

  watch(%r{^app/serializers/(.+)_serializer\.rb$}) do |m|
    [
      rspec.spec.call("controllers/v1/#{m[1]}s"),
      rspec.spec.call("requests/v1/#{m[1]}s")
    ]
  end

  watch(%r{^app/(.+/concerns/.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(mailers/.+)_mailer\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }

  # Rails config changes
  watch(rails.spec_helper) { rspec.spec_dir }
  watch(rails.routes) { "#{rspec.spec_dir}/requests" }
  watch(rails.app_controller) do
    [
      "#{rspec.spec_dir}/controllers",
      "#{rspec.spec_dir}/requests"
    ]
  end
  watch(%r{^app/mailers/application_mailer\.rb$}) { |_m| 'spec/mailers' }
end
