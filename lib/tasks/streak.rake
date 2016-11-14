namespace :streak do
  desc "View the fields and their associated values for a given pipeline. Use this to figure out the field mappings for a pipeline."
  task :debug_fields, [:pipeline_key] => :environment do |t, args|
    p = StreakClient::Pipeline.find(args[:pipeline_key])

    to_display = {}

    p[:fields].each do |field|
      to_display[field[:name]] = field
      to_display[field[:name]].delete(:name)
    end

    puts JSON.pretty_generate(to_display)
  end
end
