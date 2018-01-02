# frozen_string_literal: true

class SentryRequestClient < RestClient::Request
  # This subclass lets us add extra context to error logs with Raven. Because
  # it's a subclass of RestClient::Request and not RestClient itself, requests
  # have to use the `SentryRequestClient.execute(args)` or
  # `s = SentryRequestClient.new(args) && s.execute` format
  def initialize(args)
    Raven.extra_context(args) && super
  end
end
