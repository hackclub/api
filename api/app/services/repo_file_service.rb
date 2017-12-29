# frozen_string_literal: true
class RepoFileService
  MARKDOWN_RENDERER_OPTIONS = {
    autolink: true,
    tables: true,
    no_intra_emphasis: true,
    strikethrough: true,
    with_toc_data: true,
    fenced_code_blocks: true
  }.freeze

  def initialize(root, file_path, stylesheet)
    @root = root
    @requested_path = file_path
    @path = File.join(@root, @requested_path)
    @stylesheet = stylesheet
  end

  def mime
    MimeMagic.by_path(@path)
  end

  def handle
    return html if markdown_as_html?
    return pdf if markdown_as_pdf?

    raise Errno::ENOENT unless File.file? @path

    file
  end

  private

  def markdown_as_pdf?
    md_path = @path.ext('.md')

    File.extname(@path) == '.pdf' && File.file?(md_path)
  end

  def markdown_as_html?
    md_path = @path.ext('.md')

    File.extname(@path) == '.html' && File.file?(md_path)
  end

  def pdf
    host = Rails::Server.new.options[:Host]
    port = Rails::Server.new.options[:Port]
    path = @requested_path.ext('html')

    # This is a bit strange: we're telling PDFKit to render the HTML from the
    # given URL, so it will be able to request linked assets (like images).
    url = "http://#{host}:#{port}/v1/repo#{path}?stylesheet=true"

    kit = PDFKit.new(url)
    kit.to_pdf
  end

  def html
    md = IO.read(@path.ext('.md'))
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       MARKDOWN_RENDERER_OPTIONS)
    html = renderer.render(md)

    ActionController::Base.render(
      'repo/file.html.erb',
      assigns: { html: html, stylesheet: @stylesheet }
    )
  end

  def file
    IO.read(@path)
  end
end
