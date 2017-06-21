namespace :outreach do
  Dir[File.expand_path('outreach/*.rake', File.dirname(__FILE__))]
    .each { |file| load(file) }
end
