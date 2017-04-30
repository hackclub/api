require 'open3'

module Hackbot
  module Interactions
    class Ledger < Command
      TRIGGER = /ledger (?<args>.*)/

      USAGE = 'ledger <command> <options> <arguments>'.freeze
      DESCRIPTION = "run a report on Hack Club's finances (see docs on "\
                    'ledger-cli.org for details)'.freeze

      GH_REPO = 'hackclub/ledger'.freeze
      GH_FILE = 'main.ledger'.freeze

      def start
        data['args'] = Shellwords.split(captured[:args])

        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            downloaded_path = download_gh_file(GH_REPO, GH_FILE, GH_FILE)

            res = run_cmd('ledger', '-f', downloaded_path, *data['args'])

            # res has a trailing new line, so don't need to add a second new
            # line before the closing backticks.
            msg_channel "```\n" + res + '```'
          end
        end
      end

      private

      # Run the given command with the given arguments and return a string with
      # STDOUT and STDERR combined.
      def run_cmd(cmd, *args)
        output, = Open3.capture2e(cmd, *args)

        output
      end

      def download_gh_file(repo, file_path, downloaded_path)
        contents = GithubClient.contents(repo, path: file_path)

        if contents.encoding != 'base64'
          raise "Unknown encoding supplied by GitHub for #{repo}:#{file_path}"
        end

        decoded = Base64.decode64(contents.content)

        File.open(downloaded_path, 'w') { |f| f.write(decoded) }

        downloaded_path
      end
    end
  end
end
