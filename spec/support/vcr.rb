VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.configure_rspec_metadata!

  # Allow code coverage report to be sent to Code Climate
  c.ignore_hosts "codeclimate.com"
end
