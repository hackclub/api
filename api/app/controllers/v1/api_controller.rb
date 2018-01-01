# frozen_string_literal: true
module V1
  class ApiController < ApplicationController
    def render_success(obj = { success: true }, status = 200)
      render json: obj, status: status
    end

    def render_error(msg, status = 400)
      render json: { error: msg }, status: status
    end

    def render_not_found
      render_error('not found', 404)
    end

    def render_access_denied
      render_error('access denied', 403)
    end

    def render_field_error(field_name, error, status = 422)
      render json: { errors: { field_name => [error] } }, status: status
    end

    # errors format:
    #
    # {
    #   field_name: ['error 1', 'error 2']
    # }
    def render_field_errors(errors, status = 422)
      render json: { errors: errors }, status: status
    end
  end
end
