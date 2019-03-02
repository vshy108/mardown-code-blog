module ApplicationHelper
  def render_markdown(content)
    Redcarpet::Markdown.new(
      BlogRender,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      autolink: true,
      tables: true,
      underline: true,
      highlight: true
    ).render(
      content
    ).html_safe
  end
end
