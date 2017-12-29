# frozen_string_literal: true
module Hackbot
  module Interactions
    class UpdateWorkshops < AdminCommand
      REPO_TO_UPDATE = 'hackclub/monolith'.freeze

      TRIGGER = /update-workshops/

      USAGE = 'update-workshops'.freeze
      DESCRIPTION = 'submit a pull request to update submodules of '\
                    "`#{REPO_TO_UPDATE}` (staff only)".freeze

      def start
        fork = GithubClient.fork(REPO_TO_UPDATE)
        branches = GithubClient.branches(fork.full_name).pluck(:name)

        branch_name = branch_name(branches)

        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            msg_channel copy('progress.cloning')

            system('git', 'clone', '--recursive', fork.clone_url, '.')

            msg_channel copy('progress.configuring')

            system('git', 'config', 'user.name', git_name)
            system('git', 'config', 'user.email', git_email)

            orig_remote = `git config --get remote.origin.url`.strip
            authed_remote = authed_remote(orig_remote)

            system('git', 'remote', 'set-url', 'origin', authed_remote)

            msg_channel copy('progress.updating_from_upstream')

            system('git', 'pull', fork.source.clone_url)
            `git push origin master`

            msg_channel copy('progress.updating_submodules')

            system('git', 'checkout', '-b', branch_name)

            `git submodule foreach git pull origin master`

            if `git status -s`.empty? # If no changes were made...
              msg_channel copy('no_changes_abort')

              return :finish
            else # If changes were made...
              msg_channel copy('progress.creating_pr')

              `git add -A :/`
              `git commit -m "Update submodules"`
              system('git', 'push', '--set-upstream', 'origin', branch_name)
            end
          end
        end

        pr = GithubClient.create_pull_request(
          REPO_TO_UPDATE,
          # Branch to make PR to on upstream
          'master',
          # The "head" to make the PR from. Since we want to make it from a
          # fork, the format GitHub asks for is username:branch_name.
          "#{Octokit.user.login}:#{branch_name}",
          copy('pr.title'),
          copy('pr.body')
        )

        msg_channel copy('progress.pr_submitted', pr_url: pr.html_url)
      end

      def git_name
        GithubClient.user.name
      end

      def git_email
        GithubClient.emails.find { |e| e.primary == true }.email
      end

      # Given a URL to a git remote, this makes a copy and returns an
      # authenticated remote that includes username and access token.
      def authed_remote(orig_remote)
        remote = URI(orig_remote)
        remote.userinfo = GithubClient.user.login + ':' +
                          GithubClient.access_token

        remote.to_s
      end

      # Format: YYYY-MM-DD-update-submodules
      #
      # Padded numbers will be appended at the end of the branch name if a
      # branch already exists with the given name.
      #
      # Example branch name with padded numbers: 2017-04-17-update-submodules-02
      def branch_name(existing_branches)
        base = "#{Date.current.iso8601}-update-submodules"
        name = base

        count = 2

        while existing_branches.include? name
          padded_num = count.to_s.rjust(2, '0')
          name = base + '-' + padded_num

          count += 1
        end

        name
      end
    end
  end
end
