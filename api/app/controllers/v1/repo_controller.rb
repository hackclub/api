module V1
  class RepoController < ApplicationController
    ROOT_FILE_URI = 'v1/repo/'.freeze
    ROOT_PATH = Rails.application.secrets.repo_files_root

    def file
      uri = request.env['PATH_INFO']
      path = uri.sub(ROOT_FILE_URI, '')

      file = RepoFileService.new(ROOT_PATH, path)

      begin
        out = file.handle

        response.content_type = file.mime
        render plain: out, status: 200
      rescue Errno::ENOENT
        render plain: 'File not found', status: 404
      end
    end
  end
end
