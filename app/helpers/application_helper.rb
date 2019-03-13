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

  def render_nav_link(link_path, link_text)
    return nil if current_user.blank?

    class_name = current_page?(link_path) ? 'nav-item active' : 'nav-item'
    if current_page?(root_path) && link_path == root_path
      class_name = 'nav-item active'
    end
    content_tag(
      :li, link_to(link_text, link_path, class: 'nav-link', method: :get),
      class: class_name
    )
  end
end
