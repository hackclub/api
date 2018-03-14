# frozen_string_literal: true

# This triggers a rebuild of https://hackathons.hackclub.com on Netlify
class RebuildHackathonsSiteJob < ApplicationJob
  def perform
    SentryRequestClient.execute(
      method: :post,
      url: Rails.application.secrets.hackathons_site_rebuild_hook
    )
  end
end
