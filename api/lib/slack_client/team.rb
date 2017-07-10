module SlackClient
  module Team
    # This is an undocumented endpoint of Slack's API.
    #
    # https://github.com/ErikKalkoken/slackApiDoc/commit/4b6ce332e7fe14b92036b09c6f1aa2ec8cd96fb0
    def self.invite_user(email, access_token)
      SlackClient.rpc('users.admin.invite', access_token, email: email)
    end
  end
end
