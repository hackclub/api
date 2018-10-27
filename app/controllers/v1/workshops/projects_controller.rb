# frozen_string_literal: true

module V1
  module Workshops
    class ProjectsController < ApiController
      def index
        projects = WorkshopProject.where(workshop_slug: params[:workshop_slug])
        render_success projects
      end
    end
  end
end
