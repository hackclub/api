# frozen_string_literal: true

module V1
  module Events
    class GroupsController < ApiController
      def index
        render_success EventGroup.all
      end

      def show
        render_success EventGroup.find(params[:id])
      end
    end
  end
end
