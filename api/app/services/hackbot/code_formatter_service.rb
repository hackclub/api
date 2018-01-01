# frozen_string_literal: true

module Hackbot
  # CodeFormatterService takes strings and turns them into formatted code blocks
  # suitable for submission to Slack.
  class CodeFormatterService
    # Slack recommends limiting messages sent to channels to 4000 characters in
    # https://api.slack.com/rtm#limits.
    DEFAULT_CHAR_LIMIT = 4000

    WRAPPER = '```'
    TRUNCATED_NOTICE = '...truncated...'

    def initialize(str, char_limit = DEFAULT_CHAR_LIMIT)
      @str = str
      @char_limit = char_limit
    end

    def format
      wrap(
        truncate(
          strip_newlines(@str),
          @char_limit - wrapper_delta
        )
      )
    end

    private

    # Strip leading and trailing newlines, preserving other forms of whitespace.
    def strip_newlines(str)
      str
        .gsub(/\A[\r\n]+/, '')
        .gsub(/[\r\n]+\z/, '')
    end

    def truncate(str, char_limit)
      truncated = str.first(char_limit)

      if truncated != str
        split = truncated.split("\n")

        all_but_last_line = split[0...-1]
        all_but_last_line << TRUNCATED_NOTICE

        all_but_last_line.join("\n")
      else
        str
      end
    end

    def wrap(str)
      if str == ''
        WRAPPER + "\n" + WRAPPER
      else
        WRAPPER + "\n" + str + "\n" + WRAPPER
      end
    end

    # Length of extra characters added by wrapping.
    def wrapper_delta
      # The extra +2 is to account for the new lines that are added.
      (WRAPPER.length * 2) + 2
    end
  end
end
