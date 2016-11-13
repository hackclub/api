desc "Associate teachers in the Outreach - Teachers pipeline with their schools (which is specified in the teacher's notes)"
task associate_teachers: :environment do
  THREAD_COUNT = 4

  school_pipeline = StreakClient::Pipeline.find(
    Rails.application.secrets.streak_outreach_school_pipeline_key
  )
  teacher_pipeline = StreakClient::Pipeline.find(
    Rails.application.secrets.streak_outreach_teacher_pipeline_key
  )

  school_teacher_boxes_added_stage_key = school_pipeline[:stages].select { |_, stage| stage[:name] == "Teacher Boxes Created" }
                                         .keys
                                         .first
                                         .to_s
  teacher_lead_stage_key = teacher_pipeline[:stages].select { |_, stage| stage[:name] == "Lead" }
                           .keys
                           .first
                           .to_s

  schools = StreakClient::Box.all_in_pipeline(school_pipeline[:key])
  teachers = StreakClient::Box.all_in_pipeline(teacher_pipeline[:key])

  teachers_to_associate = teachers.select do |t|
    t[:stage_key] == teacher_lead_stage_key && t[:linked_box_keys].count.zero?
  end

  pool = Concurrent::FixedThreadPool.new(THREAD_COUNT)
  teachers_to_associate.each do |teacher|
    pool.post do
      school_name = teacher[:notes]
      school = schools.find { |s| s[:name] == school_name }

      StreakClient::Box.update(
        teacher[:key],
        linkedBoxKeys: [school[:key]],
        notes: ''
      )
      StreakClient::Box.update(
        school[:key],
        stageKey: school_teacher_boxes_added_stage_key
      )
    end
  end

  pool.wait_for_termination
end
