module V1
  class WorkshopsController < ApplicationController
    ROOT_URI = 'v1/workshops/'.freeze
    WORKSHOPS_PATH = 'vendor/hackclub'.freeze

    MARKDOWN_RENDERER_OPTIONS = {
      autolink: true,
      tables: true,
      no_intra_emphasis: true,
      strikethrough: true,
      with_toc_data: true,
      fenced_code_blocks: true
    }.freeze

    def workshops
      response.content_type = 'text/html'

      unless File.file? file_path
        render plain: 'File not found', status: 404

        return
      end

      if File.extname(file_path) == '.md'
        render_markdown
      else
        render_file
      end
    end

    private

    def render_markdown
      md = IO.read(file_path)
      renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                         MARKDOWN_RENDERER_OPTIONS)

      out = renderer.render(md)

      render plain: out, status: 200
    end

    def render_file
      response.content_type = MimeMagic.by_path(file_path)

      f = IO.read(file_path)

      render plain: f, status: 200
    end

    def file_path
      return @file_path if @file_path

      uri = request.env['PATH_INFO']
      param = uri.sub(ROOT_URI, '')

      @file_path = File.join(WORKSHOPS_PATH, param)
    end
  end
end
