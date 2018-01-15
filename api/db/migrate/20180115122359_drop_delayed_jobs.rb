# frozen_string_literal: true

class DropDelayedJobs < ActiveRecord::Migration[5.1]
  def up
    drop_table :delayed_jobs
  end

  # Copied and pasted from 20161003222152_create_delayed_jobs.rb
  def down
    create_table :delayed_jobs, force: true do |table|
      # Allows some jobs to jump to the front of the queue
      table.integer :priority, default: 0, null: false

      # Provides for retries, but still fail eventually.
      table.integer :attempts, default: 0, null: false

      # YAML-encoded string of the object that will do work
      table.text :handler, null: false

      # Reason for last failure (see note below)
      table.text :last_error

      # When to run. Could be Time.zone.now for immediately, or sometime in the
      # future.
      table.datetime :run_at

      # Set when a client is working on this object
      table.datetime :locked_at

      # Set when all retries have failed (actually, by default, the record is
      # deleted instead)
      table.datetime :failed_at

      # Who is working on this object (if locked)
      table.string :locked_by

      # The name of the queue this job is in
      table.string :queue

      table.timestamps null: true
    end

    add_index :delayed_jobs, %i[priority run_at], name: 'delayed_jobs_priority'
  end
end
