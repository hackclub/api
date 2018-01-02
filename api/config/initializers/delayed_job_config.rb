# frozen_string_literal: true

# Poll every second, instead of the default of every 5 seconds
Delayed::Worker.sleep_delay = 1
