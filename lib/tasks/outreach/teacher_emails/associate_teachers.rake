# rubocop:disable Metrics/LineLength, Metrics/MethodLength
desc "Associate teachers in the Outreach - Teachers pipeline with their schools (which is specified in the teacher's notes)"
task associate_teachers: :environment do
  def all_boxes_in_pipeline(pipeline_key, page_num = 0, boxes = [], page_size_limit = 1000)
    page = StreakClient::Box.all_in_pipeline_paginated(
      pipeline_key,
      page: page_num,
      limit: page_size_limit
    )

    boxes.push(*page[:results])

    if page[:has_next_page]
      all_boxes_in_pipeline(pipeline_key, page_num + 1, boxes)
    else
      boxes
    end
  end

  THREAD_COUNT = 8

  school_pipeline = StreakClient::Pipeline.find(
    Rails.application.secrets.streak_outreach_school_pipeline_key
  )
  teacher_pipeline = StreakClient::Pipeline.find(
    Rails.application.secrets.streak_outreach_teacher_pipeline_key
  )

  school_teacher_boxes_added_stage_key = school_pipeline[:stages].select { |_, stage| stage[:name] == 'Teacher Boxes Created' }
                                                                 .keys
                                                                 .first
                                                                 .to_s
  teacher_lead_stage_key = teacher_pipeline[:stages].select { |_, stage| stage[:name] == 'Lead' }
                                                    .keys
                                                    .first
                                                    .to_s
  school_region_field_key = school_pipeline[:fields].find { |f| f[:name] == 'Region' }[:key].to_sym

  puts 'Getting all boxes in schools pipeline'
  schools = all_boxes_in_pipeline(school_pipeline[:key])
  puts 'Getting all boxes in teacher pipeline'
  teachers = all_boxes_in_pipeline(teacher_pipeline[:key])

  teachers_to_associate = teachers.select do |t|
    t[:stage_key] == teacher_lead_stage_key && t[:linked_box_keys].count.zero?
  end

  pool = Concurrent::FixedThreadPool.new(THREAD_COUNT)
  semaphore = Mutex.new
  puts 'Starting to associate!'
  total = teachers_to_associate.length
  teachers_to_associate.each_with_index do |teacher, i|
    pool.post do
      semaphore.synchronize { puts "Starting index \##{i} out of #{total}" }
      school_name, school_region = teacher[:notes].split(' | ')
      school = schools.find { |s| s[:name] == school_name && s[:fields][school_region_field_key] == school_region }

      StreakClient::Box.update(
        teacher[:key],
        linked_box_keys: [school[:key]],
        notes: ''
      )
      StreakClient::Box.update(
        school[:key],
        stage_key: school_teacher_boxes_added_stage_key
      )
    end
  end

  pool.wait_for_termination
end
