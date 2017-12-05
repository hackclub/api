module Requests
  module RequestHelpers
    def json
      @json || JSON.parse(response.body)
    end

    # Add support for testing `options` requests in RSpec.
    #
    # See: https://github.com/rspec/rspec-rails/issues/925
    def options(*args)
      integration_session.__send__(:process, :options, *args).tap do
        copy_session_variables!
      end
    end
  end
end
