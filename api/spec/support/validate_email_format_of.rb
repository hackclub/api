# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :validate_email_format_of do |field|
  match do |instance|
    instance.send("#{field}=", 'bad_email')
    instance.validate

    instance.errors[field].include? 'is not an email'
  end
end
