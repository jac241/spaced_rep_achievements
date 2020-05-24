module ActionView::Helpers::CacheHelper

  # Simulate behaviour of Rails.cache.fetch with `force: true` option
  # This is a monkey-patch of a private method and could well break on upgrade
  #def fragment_for(name = {}, options = nil, &block)
    #force = options.try(:[], :force)
    #!force && read_fragment_for(name, options) || write_fragment_for(name, options, &block)
  #def fragment_for(name = {}, options = nil, &block)
    #force = options.try(:[], :force)

    #if content = read_fragment_for(name, options) && !force
      #binding.pry
      #@view_renderer.cache_hits[@virtual_path] = :hit if defined?(@view_renderer)
      #content
    #else
      #binding.pry
      #@view_renderer.cache_hits[@virtual_path] = :miss if defined?(@view_renderer)
      #write_fragment_for(name, options, &block)
    #end
  #end
  #end
  def fragment_for(name = {}, options = nil, &block)
    force = options.try(:delete, :force)

    if (content = read_fragment_for(name, options)) && !force
      @view_renderer.cache_hits[@virtual_path] = :hit if defined?(@view_renderer)
      content
    else
      @view_renderer.cache_hits[@virtual_path] = :miss if defined?(@view_renderer)
      write_fragment_for(name, options, &block)
    end
  end


end
