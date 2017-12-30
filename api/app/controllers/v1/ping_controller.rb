# frozen_string_literal: true
module V1
  class PingController < ApplicationController
    def ping
      render json: { result: 'pong' }
    end
  end
end
