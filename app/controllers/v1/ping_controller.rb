# frozen_string_literal: true

module V1
  class PingController < ApiController
    def ping
      render_success(result: 'pong')
    end
  end
end
