namespace :teacher_emails do
  Dir[File.expand_path("teacher_emails/*.rake", File.dirname(__FILE__))].each { |file| load(file) }
end
