# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventWebsiteClick, type: :model do
  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :event_id }
  it { should have_db_column :event_email_subscriber_id }
  it { should have_db_column :ip_address }
  it { should have_db_column :referer }
  it { should have_db_column :user_agent }

  it { should belong_to :event }
  it { should belong_to :email_subscriber }

  it { should validate_presence_of :event }
  it { should validate_presence_of :ip_address }
end
