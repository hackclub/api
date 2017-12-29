# frozen_string_literal: true
namespace :export do
  Dir[File.expand_path('export/*.rake', File.dirname(__FILE__))]
    .each { |file| load(file) }
end
