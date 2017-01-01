class V1::PingController < ApplicationController
  def ping
    render json: { result: 'pong' }
  end
end
