task dedup_teacher_leads: :environment do
  def all_boxes_in_pipeline(pipeline_key, page_num=0, boxes=[], page_size_limit=1000, &block)
    page = StreakClient::Box.all_in_pipeline_paginated(
      pipeline_key,
      page: page_num,
      limit: page_size_limit
    )

    boxes.push(*page[:results])

    block.call(page_num)

    if page[:has_next_page]
      all_boxes_in_pipeline(pipeline_key, page_num + 1, boxes, page_size_limit, &block)
    else
      boxes
    end
  end

  THREAD_COUNT = 8

  puts "Fetching pipeline info..."
  pipeline = StreakClient::Pipeline.find(
    Rails.application.secrets.streak_outreach_teacher_pipeline_key
  )
  puts "Fetching boxes in teacher pipeline..."
  boxes = all_boxes_in_pipeline(pipeline[:key]) { |i| puts "Retrieved page #{i}..." }

  lead_stage_key = pipeline[:stages].select { |_, stage| stage[:name] == "Lead" }
                   .keys
                   .first
                   .to_s
  email_field_key = pipeline[:fields].find { |f| f[:name] == "Email" }[:key].to_sym

  puts "Figuring out which boxes are dups..."
  lead_boxes = []
  existing_emails = {}

  boxes.each do |box|
    if box[:stage_key] == lead_stage_key
      lead_boxes.push(box)
    else
      email = box[:fields][email_field_key]
      existing_emails[email] = true
    end
  end

  boxes_to_delete = []
  lead_boxes.each do |box|
    email = box[:fields][email_field_key]

    if existing_emails[email]
      boxes_to_delete.push(box)
      existing_emails[email] = true
    end
  end

  puts "Deleting duplicate boxes on Streak..."

  semaphore = Mutex.new
  pool = Concurrent::FixedThreadPool.new(THREAD_COUNT)
  boxes_to_delete.each do |box|
    pool.post do
      StreakClient::Box.delete(box[:key])

      semaphore.synchronize { puts "Deleted #{box[:name]}..." }
    end
  end

  pool.shutdown
  pool.wait_for_termination
end
