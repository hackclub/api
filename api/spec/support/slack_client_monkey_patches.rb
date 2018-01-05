# frozen_string_literal: true

# This file monkey patches SlackClient to simplify testing. It's current built
# only for the tests it's being used in, so please add more methods / improve
# the methods as needed.
#
# Happy testing!
module SlackClient
  module Users
    @users = []

    # Returns randomly generated user list
    def self.list(_access_token)
      {
        ok: true,
        members: @users,
        cache_ts: nil # this should be an actual value, change if it's an issue
      }
    end

    def self.info(slack_id, _access_token)
      {
        ok: true,
        user: @users.detect { |u| u[:id] == slack_id }
      }
    end

    def self.gen_user(attrs = {})
      # set a couple default attributes, add more as needed
      attrs[:id] ||= gen_id('U')
      attrs[:team_id] ||= Rails.application.secrets.default_slack_team_id
      attrs[:name] ||= Faker::Internet.user_name
      attrs[:real_name] ||= Faker::Name.name
      attrs[:profile] ||= {}
      attrs[:profile][:email] ||= Faker::Internet.email

      @users << attrs

      attrs
    end

    def self.reset
      @users = []
    end

    def self.gen_id(prefix)
      # generation from https://stackoverflow.com/questions/88311/how-to-generate-a-random-string-in-ruby#comment21462228_88341
      id = [*('a'..'z'), *('0'..'9')].sample(8).join.upcase
      "#{prefix}#{id}"
    end
  end
end
