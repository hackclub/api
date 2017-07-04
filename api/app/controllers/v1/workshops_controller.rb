module V1
  class WorkshopsController < ApplicationController
    ROOT_URI = 'v1/workshops/'.freeze
    WORKSHOPS_PATH = Rails.application.secrets.workshop_files_root

    def workshops
      uri = request.env['PATH_INFO']
      path = uri.sub(ROOT_URI, '')

      workshops = WorkshopFileService.new(WORKSHOPS_PATH, path)

      begin
        out = workshops.handle

        response.content_type = workshops.mime
        render plain: out, status: 200
      rescue Errno::ENOENT
        render plain: 'File not found', status: 404
      end
    end
  end
end
