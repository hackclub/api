namespace :slack do
  Dir[File.expand_path('slack/*.rake', File.dirname(__FILE__))]
    .each { |file| load(file) }
end
