# frozen_string_literal: true

# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 5.0 upgrade.
#
# Read the Rails 5.0 release notes for more info on each option.

# Make Ruby 2.4 preserve the timezone of the receiver when calling `to_time`.
# Previous versions had false.
ActiveSupport.to_time_preserves_timezone = true

# Require `belongs_to` associations by default. Previous versions had false.
Rails.application.config.active_record.belongs_to_required_by_default = true

# Configure SSL options to enable HSTS with subdomains. Previous versions had
# false.
Rails.application.config.ssl_options = { hsts: { subdomains: true } }

# Rails 5 now requires belongs_to by default. For some inane reason, this
# behavior was being overriden by DelayedJob when we still used it, so our code
# was written with the assumption that belongs_to was still optional.
#
# I'm going to keep the old behavior until we have better test suite coverage to
# migrate to the new default.
#
# See https://github.com/collectiveidea/delayed_job_active_record/issues/128 for
# the DelayedJob issue.
Rails.application.config.active_record.belongs_to_required_by_default = false
