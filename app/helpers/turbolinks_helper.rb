module TurbolinksHelper
  def no_cache
    content_for :head do
      '<meta name="turbolinks-cache-control" content="no-cache">'.html_safe
    end
  end
end
