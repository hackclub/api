# frozen_string_literal: true

GithubClient.configure do |c|
  c.access_token = Rails.application.secrets.github_bot_access_token
end
