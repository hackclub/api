module V1
  class RepoController < ApplicationController
    ROOT_FILE_URI = 'v1/repo/'.freeze
    ROOT_PATH = Rails.application.secrets.repo_files_root

    def file
      out = file_service.handle

      response.content_type = file_service.mime
      render plain: out, status: 200
    rescue Errno::ENOENT
      render plain: 'File not found', status: 404
    end

    private

    def file_service
      uri = request.env['PATH_INFO']
      path = uri.sub(ROOT_FILE_URI, '')
      stylesheet = params[:stylesheet]

      RepoFileService.new(ROOT_PATH, path, stylesheet)
    end
  end
end
