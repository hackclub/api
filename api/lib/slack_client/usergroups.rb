# frozen_string_literal: true
module SlackClient
  module Usergroups
    def self.users_add(usergroup_id, user_id, access_token)
      users = users_list(usergroup_id, access_token)

      return users unless users[:ok]

      users_update(usergroup_id, users[:users] << user_id, access_token)
    end

    def self.users_list(usergroup_id, access_token)
      SlackClient.rpc('usergroups.users.list', access_token,
                      usergroup: usergroup_id)
    end

    def self.users_update(usergroup_id, user_ids, access_token)
      user_ids = user_ids.join(',')

      SlackClient.rpc('usergroups.users.update', access_token,
                      users: user_ids,
                      usergroup: usergroup_id)
    end
  end
end
