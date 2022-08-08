module ApplicationHelper

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def namespace
    controller_path.split('/').first
  end

  def hyphenate str
    str.downcase.gsub(' ', '-')
  end

  def devise_actions
    (controller?('devise/sessions') and action?('new')) or (controller?('users/registrations') and action?('new')) or controller?('devise/passwords')
  end

  def navbar_link
    content_tag(:ul, class: "nav nav-sidebar") do
      yield
    end
  end

  def nav_link (text, path)
    options = current_page?(path) ? { class: "active" } : {}
    content_tag(:li, options) do
      link_to text, path
    end
  end

  def flash_class(level)
    case level
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-danger"
    end
  end

  def to_formatted_date timestamp
    Time.at(timestamp).strftime('%m/%d/%Y')
  end

  def errors_for(object)
    if object.errors.any?
        content_tag(:div, class: "card text-white bg-danger") do
          concat(content_tag(:div, class: "card-body") do
              concat(content_tag(:h4, class: "card-title") do
                  concat "#{pluralize(object.errors.count.to_s, "error")} prohibited this #{object.class.name.downcase} from being saved:"
              end)
              concat(content_tag(:ul) do
                  object.errors.full_messages.each do |msg|
                      concat content_tag(:li, msg)
                  end
              end)
          end)
        end
    end
  end

  def feature? name
    Feature.enabled(name, current_user)
  end

  def show_background product
    if product.present? and product.configurations.present?
      if product.configurations[:background_type] == 'color'
        background = product.configurations[:background_color]
      elsif product.configurations[:background_type] == 'image'
        background = "url(#{product.background_url})"
      end
    end
  end

end
