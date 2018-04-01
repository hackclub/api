# frozen_string_literal: true

FactoryBot.define do
  factory :event_website_click do
    event nil
    event_email_subscriber nil
    ip_address ''
    referer 'MyText'
    user_agent 'MyText'
  end
end
