# frozen_string_literal: true

module V1
  class AttachmentsController < ApiController
    def create
      a = Attachment.new(type: params[:type].camelize, file: params[:file])

      if a.save
        render_success(a, 201)
      else
        render_field_errors(a.errors)
      end
    rescue ActiveRecord::SubclassNotFound
      # ActiveRecord::SubclassNotFound is thrown when the user provides a type
      # that isn't specified through STI.
      render_field_errors(type: ['unknown type'])
    end

    def show
      a = Attachment.find(params[:id])
      render_success(a)
    end
  end
end
