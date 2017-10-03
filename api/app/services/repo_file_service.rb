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
    @path = File.join(@root, file_path)
  end

  def mime
    MimeMagic.by_path(@path)
  end

  def handle
    return markdown if markdown_as_html?

    raise Errno::ENOENT unless File.file? @path

    file
  end

  private

  def markdown_as_html?
    md_path = @path.ext('.md')

    File.extname(@path) == '.html' && File.file?(md_path)
  end

  def markdown
    md = IO.read(@path.ext('.md'))
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       MARKDOWN_RENDERER_OPTIONS)

    renderer.render(md)
  end

  def file
    IO.read(@path)
  end
end
