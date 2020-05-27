module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def home_page?
    # FIXME why doesn't this always work???
    params[:controller] == "home" && params[:action] == "index"
  end

  def nav_link_classes(link_object:, active_object:)
    classes = ["nav-link"]

    if link_object == active_object
      classes << "active"
    end

    classes
  end

end
