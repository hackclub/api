# frozen_string_literal: true

module V1
  module Workshops
    class ProjectsController < ApiController
      USER_AUTH = { only: [] }.freeze # we want to manually make the auth call
      include UserAuth

      def index
        projects = WorkshopProject.where(workshop_slug: params[:workshop_slug])
        render_success projects
      end

      def create
        authenticate_user if request.headers.include? 'Authorization'

        project = WorkshopProject.new(project_params)

        project.workshop_slug = params[:workshop_slug]
        project.screenshot = screenshot if screenshot
        project.user = current_user if current_user

        if project.save
          render_success project, 201
        else
          render_field_errors project.errors
        end
      end

      private

      def project_params
        params.permit(
          :live_url,
          :code_url
        )
      end

      def screenshot
        id = params[:screenshot_id]
        WorkshopProjectScreenshot.find(id) if id
      end
    end
  end
end
