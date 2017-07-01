module V1
  class WorkshopsController < ApplicationController
    ROOT_URI = 'v1/workshops/'.freeze
    WORKSHOPS_PATH = 'vendor/hackclub'.freeze

    MARKDOWN_RENDERER_OPTIONS = { autolink: true, tables: true }.freeze

    def workshops
      renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                         MARKDOWN_RENDERER_OPTIONS)

      response.content_type = 'text/html'

      begin
        md = IO.read(file_path)

        out = renderer.render(md)

        render text: out, status: 200
      rescue Errno::ENOENT
        render text: 'File not found', status: 404
      end
    end

    def file_path
      uri = request.env['PATH_INFO']
      param = uri.sub(ROOT_URI, '')

      File.join(WORKSHOPS_PATH, param)
    end
  end
end
