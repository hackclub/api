class RepoFileService
  MARKDOWN_RENDERER_OPTIONS = {
    autolink: true,
    tables: true,
    no_intra_emphasis: true,
    strikethrough: true,
    with_toc_data: true,
    fenced_code_blocks: true
  }.freeze

  def initialize(root, file_path)
    @root = root
    @requested_path = file_path
    @path = File.join(@root, @requested_path)
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

  def pdf_stylesheet
    File.expand_path('pdf_stylesheet.css', File.dirname(__FILE__))
  end

  def pdf
    host = Rails::Server.new.options[:Host]
    port = Rails::Server.new.options[:Port]
    path = @requested_path.ext('html')

    # Something like
    # http://0.0.0.0:3000/v1/repo/workshops/personal_website/README.html
    # 
    # This is a bit strange: we're telling PDFKit to render the HTML from the
    # given URL, so it will be able to request linked assets (like images).
    url = "http://#{host}:#{port}/v1/repo#{path}"

    kit = PDFKit.new(url)
    kit.to_pdf
  end

  def html
    md = IO.read(@path.ext('.md'))
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       MARKDOWN_RENDERER_OPTIONS)

    renderer.render(md)
  end

  def file
    IO.read(@path)
  end
end
