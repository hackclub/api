# frozen_string_literal: true

namespace :streak do
  desc 'View the fields and their associated values for a given pipeline. Use '\
       'this to figure out the field mappings for a pipeline.'
  task :debug_fields, [:pipeline_key] => :environment do |_t, args|
    p = StreakClient::Pipeline.find(args[:pipeline_key])

    to_display = {}

    p[:fields].each do |field|
      to_display[field[:name]] = field
      to_display[field[:name]].delete(:name)
    end

    puts JSON.pretty_generate(to_display)
  end

  desc 'View the stages and their associated keys for a given pipeline. Use '\
       'this to figure out the stage mappings for a pipeline.'
  task :debug_stages, [:pipeline_key] => :environment do |_t, args|
    p = StreakClient::Pipeline.find(args[:pipeline_key])

    ordered_stages = []

    p[:stage_order].each do |stage_key|
      ordered_stages << p[:stages][stage_key.to_sym]
    end

    ordered_stages.each do |stage|
      puts "#{stage[:key]} -> #{stage[:name]}"
    end
  end
end
