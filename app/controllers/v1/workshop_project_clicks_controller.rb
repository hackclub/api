# frozen_string_literal: true

module V1
  class WorkshopProjectClicksController < ApiController
    USER_AUTH = { only: [] }.freeze # we want to manually make the auth call
    include UserAuth

    def create
      authenticate_user if request.headers.include? 'Authorization'

      project = WorkshopProject.find(params[:project_id])

      click = WorkshopProjectClick.create!(
        type_of: params[:type_of],
        workshop_project: project,
        user: current_user,
        ip_address: request.ip,
        user_agent: request.user_agent
      )

      redirect_to click.type_of == 'code' ? project.code_url : project.live_url
    end
  end
end
