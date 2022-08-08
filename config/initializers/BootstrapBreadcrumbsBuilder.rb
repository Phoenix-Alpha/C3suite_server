class BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    @context.content_tag(:ul, class: 'breadcrumb pl-0') do
      @elements.collect do |element|
        render_element(element)
      end.join.html_safe
    end
  end

  def render_element(element)
    current = @context.current_page?(compute_path(element))

    @context.content_tag(:li, :class => ('active' if current)) do
      link_or_text = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options = {'data-turbolinks': "false"} )
      divider = @context.content_tag(:span, (@options[:separator]  || '/').html_safe, :class => 'divider') unless current

      link_or_text + (divider || '')
    end
  end
end